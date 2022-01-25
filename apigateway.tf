//variable "rest-api-name" {}
//variable "subnet_id" {}

resource "aws_api_gateway_rest_api" "test" {
  name = var.aws_api_gateway_rest_api_name
  endpoint_configuration {
      types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "APIProxyResource" {
  rest_api_id = aws_api_gateway_rest_api.test.id
  parent_id   = aws_api_gateway_rest_api.test.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "test" {
  rest_api_id   = aws_api_gateway_rest_api.test.id
  resource_id   = aws_api_gateway_resource.APIProxyResource.id
  http_method   = "ANY"
  authorization = "NONE"

  request_parameters = {
      "method.request.path.proxy" = true
  } 

  request_models = {
    "application/json" = "Error"
  }
}

resource "aws_api_gateway_integration" "test" {
  rest_api_id = aws_api_gateway_rest_api.test.id
  resource_id = aws_api_gateway_resource.APIProxyResource.id
  http_method = aws_api_gateway_method.test.http_method

  request_templates = {
    "application/json" = ""
    "application/xml"  = "#set($inputRoot = $input.path('$'))\n{ }"
  }

  request_parameters = {
    "integration.request.header.X-Authorization" = "'static'"
    "integration.request.header.X-Foo"           = "'Bar'"
  }

  type                    = "HTTP"
  uri                     = aws_lb.msknlb.id
  integration_http_method = "GET"
  passthrough_behavior    = "WHEN_NO_MATCH"
  content_handling        = "CONVERT_TO_TEXT"

  connection_type = "VPC_LINK"
  connection_id   = aws_api_gateway_vpc_link.msknlb.id
}

resource "aws_api_gateway_api_key" "msknlb" {
  name = "msknlbtestapikey"
}

resource "aws_api_gateway_deployment" "ApiDeployment" {
  depends_on = [aws_api_gateway_method.test]
  rest_api_id = "${aws_api_gateway_rest_api.test.id}"
  stage_name = "${var.stage_name}"
}