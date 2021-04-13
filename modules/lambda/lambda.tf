### This Lambda is to connect to an ec2 instance with ssh and run a command

resource "aws_lambda_layer_version" "package_layer" {
  layer_name          = "layer-for-miserere-lambda"
  s3_bucket           = "miserere-s3-for-packageparamiko"
  s3_key              = "packageParamiko.zip"
  compatible_runtimes = ["python3.8"]
}

resource "aws_lambda_function" "lambda_function" {
  function_name = "miserere-lambda"
  timeout       = "15"

  # the bucket name as created earlier
  s3_bucket = "miserere-s3-for-packageparamiko"
  s3_key    = "lambda-payload.zip"

  # handler is name-of-the-script.function-name (the function that inside the python script).
  handler = "lambda-payload.funckey"
  runtime = "python3.8"

  role = aws_iam_role.miserere_role_for_lambda_payload.arn

  layers = [aws_lambda_layer_version.package_layer.arn]
}

# IAM role which dictates what aws services the lambda function may access.
resource "aws_iam_role_policy" "policy_for_lambda7_role" {
  name = "policy_for_lambda7_role"
  role = aws_iam_role.miserere_role_for_lambda_payload.id
  policy = file("modules/lambda/policies/cust-pol.json")
}

resource "aws_iam_role" "miserere_role_for_lambda_payload" {
  name = "miserere_role_for_lambda_payload"

  assume_role_policy = file("modules/lambda/policies/ec2-assume-policy.json")
}
