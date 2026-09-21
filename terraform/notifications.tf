resource "aws_sns_topic" "alerts" {
  name = "${local.name}-alerts"

  tags = {
    Name        = "${local.name}-alerts"
    Environment = var.environment
  }
}
resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}
