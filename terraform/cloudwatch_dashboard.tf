resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${local.name_prefix}-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      # =========================
      # Ligne KPI (haut du dashboard)
      # =========================
      {
        "type" : "metric",
        "x" : 0, "y" : 0, "width" : 8, "height" : 4,
        "properties" : {
          "title" : "KPI - CPU moyenne ASG (%)",
          "region" : var.aws_region,
          "view" : "singleValue",
          "stat" : "Average",
          "period" : 60,
          "metrics" : [
            ["AWS/EC2", "CPUUtilization", "AutoScalingGroupName", aws_autoscaling_group.web.name]
          ]
        }
      },
      {
        "type" : "metric",
        "x" : 8, "y" : 0, "width" : 8, "height" : 4,
        "properties" : {
          "title" : "KPI - Instances InService",
          "region" : var.aws_region,
          "view" : "singleValue",
          "stat" : "Average",
          "period" : 60,
          "metrics" : [
            ["AWS/AutoScaling", "GroupInServiceInstances", "AutoScalingGroupName", aws_autoscaling_group.web.name]
          ]
        }
      },
      {
        "type" : "metric",
        "x" : 16, "y" : 0, "width" : 8, "height" : 4,
        "properties" : {
          "title" : "KPI - Capacité désirée (Desired)",
          "region" : var.aws_region,
          "view" : "singleValue",
          "stat" : "Average",
          "period" : 60,
          "metrics" : [
            ["AWS/AutoScaling", "GroupDesiredCapacity", "AutoScalingGroupName", aws_autoscaling_group.web.name]
          ]
        }
      },

      # =========================
      # Graphes principaux
      # =========================
      {
        "type" : "metric",
        "x" : 0, "y" : 4, "width" : 12, "height" : 6,
        "properties" : {
          "title" : "ASG - CPUUtilization (Average)",
          "region" : var.aws_region,
          "view" : "timeSeries",
          "stat" : "Average",
          "period" : 60,
          "metrics" : [
            ["AWS/EC2", "CPUUtilization", "AutoScalingGroupName", aws_autoscaling_group.web.name]
          ]
        }
      },
      {
        "type" : "metric",
        "x" : 12, "y" : 4, "width" : 12, "height" : 6,
        "properties" : {
          "title" : "ASG - Instances (Desired vs InService)",
          "region" : var.aws_region,
          "view" : "timeSeries",
          "stat" : "Average",
          "period" : 60,
          "metrics" : [
            ["AWS/AutoScaling", "GroupDesiredCapacity", "AutoScalingGroupName", aws_autoscaling_group.web.name],
            [".", "GroupInServiceInstances", ".", "."]
          ]
        }
      },
      {
        "type" : "metric",
        "x" : 0, "y" : 10, "width" : 12, "height" : 6,
        "properties" : {
          "title" : "ASG - Instances (Pending / Terminating)",
          "region" : var.aws_region,
          "view" : "timeSeries",
          "stat" : "Average",
          "period" : 60,
          "metrics" : [
            ["AWS/AutoScaling", "GroupPendingInstances", "AutoScalingGroupName", aws_autoscaling_group.web.name],
            [".", "GroupTerminatingInstances", ".", "."]
          ]
        }
      },

      # =========================
      # Widget alarme (propre)
      # =========================
      {
        "type" : "alarm",
        "x" : 12, "y" : 10, "width" : 12, "height" : 6,
        "properties" : {
          "title" : "Alarmes - CPU ASG",
          "alarms" : [
            aws_cloudwatch_metric_alarm.asg_cpu_high.arn
          ]
        }
      }
    ]
  })
}
