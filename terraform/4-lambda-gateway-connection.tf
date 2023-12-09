resource "aws_apigatewayv2_integration" "lambda_router" {
  api_id = aws_apigatewayv2_api.main.id

  integration_uri    = aws_lambda_function.router.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "catch_all" {
  api_id = aws_apigatewayv2_api.main.id

  route_key = "ANY /{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_router.id}"
}

resource "aws_apigatewayv2_route" "base_path" {
  api_id = aws_apigatewayv2_api.main.id

  route_key = "ANY /"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_router.id}"
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.router.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.main.execution_arn}/*/*"
}

output "api_base_url" {
  value = aws_apigatewayv2_stage.dev.invoke_url
}