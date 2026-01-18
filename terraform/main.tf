############################################
# main.tf — Projet M1 Cloud (Scalabilité + SSM)
# - VPC par défaut
# - Launch Template + Auto Scaling Group
# - Target Tracking CPU
# - SSM (Session Manager / Run Command) sans SSH
############################################

# --- Data sources : VPC par défaut, subnets, AMI Amazon Linux ---

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

locals {
  name_prefix = replace(lower(var.project_name), " ", "-")
}

# --- Security Group : HTTP only (no SSH) ---

resource "aws_security_group" "asg" {
  name        = "${local.name_prefix}-asg-sg"
  description = "SG for ASG instances (HTTP only)"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Outbound allowed"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Project = var.project_name
  }
}

# --- User data : mini serveur HTTP pour test (port 80) ---

locals {
  user_data = <<-EOF
    #!/bin/bash
    set -eux
    dnf -y update
    dnf -y install nginx
    systemctl enable nginx
    echo "Projet M1 Cloud - ASG instance: $(hostname)" > /usr/share/nginx/html/index.html
    systemctl start nginx
  EOF
}

# --- IAM role for EC2 (SSM) ---

resource "aws_iam_role" "ec2_ssm_role" {
  name = "${local.name_prefix}-ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = {
    Project = var.project_name
  }
}

resource "aws_iam_role_policy_attachment" "ec2_ssm_core" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_ssm_profile" {
  name = "${local.name_prefix}-ec2-ssm-profile"
  role = aws_iam_role.ec2_ssm_role.name

  tags = {
    Project = var.project_name
  }
}

# --- Launch Template ---

resource "aws_launch_template" "web" {
  name_prefix   = "${local.name_prefix}-lt-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.asg.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_ssm_profile.name
  }

  user_data = base64encode(local.user_data)

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name    = "${var.project_name}-asg-instance"
      Project = var.project_name
    }
  }

  # Optionnel mais recommandé : tagger les volumes EBS
  tag_specifications {
    resource_type = "volume"
    tags = {
      Project = var.project_name
    }
  }

  tags = {
    Project = var.project_name
  }
}

# --- Auto Scaling Group ---

resource "aws_autoscaling_group" "web" {
  name                = "${local.name_prefix}-asg"
  desired_capacity    = var.asg_desired
  min_size            = var.asg_min
  max_size            = var.asg_max
  vpc_zone_identifier = data.aws_subnets.default.ids

  health_check_type         = "EC2"
  health_check_grace_period = 60

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  tag {
    key                 = "Project"
    value               = var.project_name
    propagate_at_launch = true
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-asg-instance"
    propagate_at_launch = true
  }
}

# --- Scaling policy : Target Tracking CPU ---

resource "aws_autoscaling_policy" "cpu_target" {
  name                   = "${local.name_prefix}-cpu-target"
  autoscaling_group_name = aws_autoscaling_group.web.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = var.cpu_target
  }
}
