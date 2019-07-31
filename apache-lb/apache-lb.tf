# This module builds an Application Load balancer
# Create the Application Load Balancer, attached to the given subnets

resource "aws_lb" "alb" {
  name            = var.name_prefix
  security_groups = [
    aws_security_group.lb_security_group.id]
  subnets         =  var.public_subnets_in_vpc
  load_balancer_type = "application"
  tags = {
    Environment = "PGPCC"
    Stack = "PGPCC CAPSTON"
  }
}

# Create a target group to send traffic to  Apache server
resource "aws_lb_target_group" "alb_tg" {
  name      = "${var.name_prefix}-alb-tg"
  port      = var.http_port
  protocol  = "HTTP"
  vpc_id    = var.vpc_id
}

# Attach the Apache EC2 instance to the target group
resource "aws_lb_target_group_attachment" "tg_attach" {
  count = var.apache_server_count
  target_group_arn  = aws_lb_target_group.alb_tg.arn
  target_id         = element(var.apache_instance_ids , count.index)
  port              = var.http_port
}


# Associate the listener resource to the load balancer, and configure SSL
resource "aws_lb_listener" "lb-listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.lb-port
  protocol          = "HTTP"

  default_action {
    target_group_arn  = aws_lb_target_group.alb_tg.arn
    type              = "forward"
  }
}

