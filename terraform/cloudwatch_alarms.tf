resource "aws_cloudwatch_metric_alarm" "asg_cpu_high" {
  alarm_name        = "${local.name_prefix}-asg-cpu-high"
  alarm_description = "Alerte : CPU moyenne de l’Auto Scaling Group trop élevée."
  actions_enabled   = true

  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  period              = 60
  statistic           = "Average"
  threshold           = var.cpu_alarm_threshold
  treat_missing_data  = "notBreaching"

  namespace   = "AWS/EC2"
  metric_name = "CPUUtilization"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web.name
  }

  alarm_actions = [aws_sns_topic.alerts.arn]
  ok_actions    = [aws_sns_topic.alerts.arn]

  tags = {
    Project = var.project_name
  }
}
