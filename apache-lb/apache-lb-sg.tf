#-------------------
# LB security group
#-------------------
resource "aws_security_group" "lb_security_group" {
  name = "${var.name_prefix}-lb-sg"
  description = "Security group for the load balancer"
  vpc_id = var.vpc_id

  tags = {
    Name = "lb_security_group"
  }
}

# Allow HTTPS in from specific external subnets if public access is not enabled
resource "aws_security_group_rule" "allow_lb_https_inbound" {
  type        = "ingress"
  from_port   = var.lb-port
  to_port     = var.lb-port
  protocol    = "tcp"
  cidr_blocks = [ "0.0.0.0/0" ]
  security_group_id = aws_security_group.lb_security_group.id
}

resource "aws_security_group_rule" "allow_lb_https_inbound_apache" {
  type        = "ingress"
  from_port   = var.lb-port
  to_port     = var.lb-port
  protocol    = "tcp"
  cidr_blocks = var.private_subnet_cidrs
  security_group_id = aws_security_group.lb_security_group.id
}

resource "aws_security_group_rule" "allow_lb_outbound" {
  type = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.lb_security_group.id
}

