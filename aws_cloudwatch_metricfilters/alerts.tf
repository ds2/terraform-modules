resource "aws_cloudwatch_metric_alarm" "signinfails" {
  alarm_name                = "Console sign-in failures"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "ConsoleSigninFailureCount"
  namespace                 = "AWS/EC2"
  period                    = "60"
  statistic                 = "Sum"
  threshold                 = var.loginThreshold
  alarm_description         = "There are too many failed login attempts. Please check the CW Metrics Loggroup to find out who tried to login!"
  insufficient_data_actions = var.snsNoDataArns
  alarm_actions             = var.snsAlarmArns
  ok_actions                = var.snsOkArns
  actions_enabled           = var.enabled
  treat_missing_data        = "notBreaching"
  tags = {
    Name        = "Console sign-in failures"
    Terraformed = true
  }
}
