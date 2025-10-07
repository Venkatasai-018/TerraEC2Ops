resource "aws_cloudwatch_event_rule" "start" {
  name        = "autostart"
  description = "Creation of Cloudwatch alert Rule for start"
  schedule_expression = var.start_schedule

}


resource "aws_cloudwatch_event_rule" "stop" {
  name        = "autostop"
  description = "Creation of Cloudwatch alert Rule for stop"
  schedule_expression = var.stop_schedule

}


resource "aws_cloudwatch_event_target" "start" {
  rule      = aws_cloudwatch_event_rule.start.name
  
  arn       = aws_lambda_function.startec2.arn


}



resource "aws_cloudwatch_event_target" "stop" {
  rule      = aws_cloudwatch_event_rule.stop.name
  
  arn       = aws_lambda_function.stopec2.arn
}