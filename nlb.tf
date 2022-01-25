
data "aws_vpc" "msknlb" {
  filter {
    name   = "tag:Name"
    values = ["MMVPC"]
  }
}

data "aws_subnet_ids" "msknlb" {
  vpc_id = data.aws_vpc.msknlb.id

  tags = {
    Purpose = "msknlb"
  }
}

resource "aws_lb" "msknlb" {
  name               = "lb-msk-test"
  load_balancer_type = "network"
  internal           = true
  subnets            = data.aws_subnet_ids.msknlb.ids
}

resource "aws_lb_listener" "msknlb" {
  for_each = var.ports

  load_balancer_arn = aws_lb.msknlb.arn

  protocol = "TCP"
  port     = each.value

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.msknlb[each.key].arn
  }
}

resource "aws_lb_target_group" "msknlb" {
  for_each = var.ports

  port     = each.value
  protocol = "TCP"
  vpc_id   = data.aws_vpc.msknlb.id
  // deregistration_delay = 90
  // stickiness = []
  health_check {
    interval            = 30
    port                = 8082
    //port                = each.value != "TCP_UDP" ? each.key : 80
    protocol            = "TCP"
   // timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
  depends_on = [
    aws_lb.msknlb
  ]

  lifecycle {
    create_before_destroy = true
  }
}
