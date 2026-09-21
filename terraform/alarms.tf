resource "aws_cloudwatch_metric_alarm" "ecs_cpu_high" {
  alarm_name          = "${local.name}-ecs-cpu-high"
  alarm_description   = "ECS service CPU utilization is too high"
  comparison_operator = "GreaterThanThreshold"

  evaluation_periods = 2
  period             = 300
  metric_name        = "CPUUtilization"
  namespace          = "AWS/ECS"
  statistic          = "Average"
  threshold          = 80

  dimensions = {
    ClusterName = aws_ecs_cluster.main.name
    ServiceName = aws_ecs_service.app.name
  }

  alarm_actions = [
    aws_sns_topic.alerts.arn
  ]

  tags = {
    Name        = "${local.name}-ecs-cpu-high"
    Environment = var.environment
  }
}
resource "aws_cloudwatch_metric_alarm" "alb_unhealthy_targets" {
  alarm_name          = "${local.name}-alb-unhealthy-targets"
  alarm_description   = "ALB has unhealthy ECS targets"
  comparison_operator = "GreaterThanThreshold"

  evaluation_periods = 2
  period             = 60
  metric_name        = "UnHealthyHostCount"
  namespace          = "AWS/ApplicationELB"
  statistic          = "Average"
  threshold          = 0

  dimensions = {
    LoadBalancer = aws_lb.app.arn_suffix
    TargetGroup  = aws_lb_target_group.app.arn_suffix
  }

  alarm_actions = [
    aws_sns_topic.alerts.arn
  ]

  tags = {
    Name        = "${local.name}-alb-unhealthy-targets"
    Environment = var.environment
  }
}