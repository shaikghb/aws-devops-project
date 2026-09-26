# CloudWatch application error monitoring

resource "aws_cloudwatch_log_metric_filter" "application_errors" {
  name           = "${local.name}-application-errors"
  log_group_name = aws_cloudwatch_log_group.app.name
  pattern        = "ERROR"

  metric_transformation {
    name      = "${local.name}-application-error-count"
    namespace = "Application/${local.name}"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "application_errors" {
  alarm_name          = "${local.name}-application-errors"
  alarm_description   = "Application logs contain ERROR messages"
  comparison_operator = "GreaterThanOrEqualToThreshold"

  evaluation_periods = 1
  period             = 60
  metric_name        = "${local.name}-application-error-count"
  namespace          = "Application/${local.name}"
  statistic          = "Sum"
  threshold          = 1

  treat_missing_data = "notBreaching"

  alarm_actions = [
    aws_sns_topic.alerts.arn
  ]

  tags = {
    Name        = "${local.name}-application-errors"
    Environment = var.environment
  }
}