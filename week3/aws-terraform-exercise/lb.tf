# Define Security Group for an Application Load Balancer
resource "aws_security_group" "alb" {
  name   = local.sg_alb_name
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = local.sg_alb_name
  }
}

# Define an Application Load Balancer
resource "aws_lb" "alb" {
  name            = local.alb_name
  security_groups = [aws_security_group.alb.id]
  subnets         = [aws_subnet.pub_a.id, aws_subnet.pub_b.id]

  tags = {
    Name = local.alb_name
  }
}

# Define a Target Group for the Application Load Balancer
resource "aws_lb_target_group" "alb" {
  name        = local.alb_tg_name
  target_type = "ip"
  port        = var.alb_tg_port
  protocol    = var.alb_tg_proto
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = local.alb_tg_name
  }
}

# Define a Listener for the Application Load Balancer
resource "aws_lb_listener" "alb_listener_http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"
  # ssl_policy        = "ELBSecurityPolicy-2016-08"
  # certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb.arn
  }
}
