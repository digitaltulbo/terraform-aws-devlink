# Web Load Balancer (Application)
resource "aws_lb" "web_lb" {
  name               = "web-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.groomVPC-sg.id]
  subnets            = [aws_subnet.public_web_a.id, aws_subnet.public_web_c.id]
}

# Web Load Balancer Listener
resource "aws_lb_listener" "web_lb_listener" {
  load_balancer_arn = aws_lb.web_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_lb_tg.arn
  }
}

# Web Load Balancer Target Group
resource "aws_lb_target_group" "web_lb_tg" {
  name        = "web-lb-tg"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.groomVPC.id
}

# App Load Balancer (Application)
resource "aws_lb" "app_lb" {
  name               = "app-lb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.groomVPC-sg.id]
  subnets            = [aws_subnet.private_app_a.id, aws_subnet.private_app_c.id]
}

# App Load Balancer Listener
resource "aws_lb_listener" "app_lb_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_lb_tg.arn
  }
}

# App Load Balancer Target Group
resource "aws_lb_target_group" "app_lb_tg" {
  name        = "app-lb-tg"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.groomVPC.id
}