resource "random_id" "name" {
  byte_length = 8
  prefix      = "${var.codebuild_name}-"
}

resource "aws_cloudwatch_event_rule" "events" {
  name = "${random_id.name.hex}"

  event_pattern = <<PATTERN
{
  "source": [
    "aws.codebuild"
  ],
  "detail-type": [
    "CodeBuild Build State Change"
  ],
  "detail": {
    "build-status": ${jsonencode(var.codebuild_status)},
    "project-name": ["${var.codebuild_name}"] 
  }
}
PATTERN
}

resource "aws_cloudwatch_event_target" "events" {
  target_id = "${random_id.name.hex}"
  rule      = "${aws_cloudwatch_event_rule.events.name}"
  arn       = "${var.lambda_function_arn}"
}

resource "aws_lambda_permission" "events" {
  statement_id  = "${random_id.name.hex}"
  action        = "lambda:InvokeFunction"
  function_name = "${var.lambda_function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.events.arn}"
}
