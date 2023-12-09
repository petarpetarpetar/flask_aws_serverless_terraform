resource "aws_iam_role" "router_lambda_exec" {
  name = "router-lambda"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "router_lambda_policy" {
  role       = aws_iam_role.router_lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda function 'router' with code located in an S3 bucket
resource "aws_lambda_function" "router" {
  function_name = "router"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.lambda_router.key

  runtime = "python3.8"
  handler = "router.handler"

  source_code_hash = data.archive_file.lambda_router.output_base64sha256

  role = aws_iam_role.router_lambda_exec.arn
}

# CloudWatch Logs log group for storing Lambda function's logs
resource "aws_cloudwatch_log_group" "router" {
  name = "/aws/lambda/${aws_lambda_function.router.function_name}"

  retention_in_days = 7
}

data "archive_file" "lambda_router" {
  type = "zip"

  source_dir  = "../package"
  output_path = "../deployment_package.zip"
}

resource "aws_s3_object" "lambda_router" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "router.zip"
  source = data.archive_file.lambda_router.output_path

  etag = filemd5(data.archive_file.lambda_router.output_path)
}
