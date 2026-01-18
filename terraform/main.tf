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

# --- Security Group minimal ---

resource "aws_security_group" "ec2_min" {
  name        = "${replace(lower(var.project_name), " ", "-")}-ec2-min"
  description = "Minimal SG for test EC2"
  vpc_id      = data.aws_vpc.default.id

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

# --- EC2 minimale de test ---

resource "aws_instance" "test" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t3.micro"
  subnet_id                   = data.aws_subnets.default.ids[0]
  vpc_security_group_ids      = [aws_security_group.ec2_min.id]
  associate_public_ip_address = true

  tags = {
    Name    = "${var.project_name}-test-ec2"
    Project = var.project_name
  }
}
