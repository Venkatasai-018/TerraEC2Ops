resource "aws_sns_topic" "autosns" {
  name = "autosns"
}


resource "aws_sns_topic_subscription" "autosns" {
  topic_arn = aws_sns_topic.autosns.arn
  protocol = "email"
  endpoint = var.email
}