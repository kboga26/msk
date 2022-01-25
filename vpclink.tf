resource "aws_api_gateway_vpc_link" "msknlb" {
  name        = "vpclink-mskapinlb-test"
  description = "example description"
  target_arns = [aws_lb.msknlb.arn]
}