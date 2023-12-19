# Web Load Balancer

resource "aws_lb" "web-lb"{
  name = "web-lb"
  internal = false	 # true = 내부(internal) / false = 외부(Internet-facing)
  load_balancer_type = "application" # Default - application, 다른 하나는 gateway
  security_groups = [aws_security_group.main-sg.id]
  subnets = [aws_subnet.private_subnet_a.id, aws_subnet.public_subnet_c.id]

  tags = {
      Name = "Web-Load-Balancer"
  }
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

# Web Target Groups
resource "aws_lb_target_group" "web-lb-tg"{
  name    = "web-lb-tg"
  port    = "80"
  protocol   = "HTTP"
  vpc_id  = aws_vpc.main.id
  target_type = "instance"
  
  health_check {
    path = "/health" # 앞서 AppInstance 사전 구축 시, curl로 헬스 체크 테스트했던 경로
    protocol = "HTTP"
    healthy_threshold  = 2 # 헬스 체크 문제 시, 정상 요청 반환이 될때까지의 최대 재요청 수(정상 간주)
    unhealthy_threshold = 2 # 헬스 체크 문제 시, 최대 실패 횟수 Limit
      # 결론은 헬스 체크 제대로 안될 때 최대 2번까지는 시도한다
    interval = 30 # 헬스 체크 인터벌(초)
    timeout = 5 # 해당 시간(초)내 응답이 없으면 실패 간주
  }

  tags = {
      Name = "Web-LoadBalancer-TargetGroup"
  }
}

# App Load Balancer
resource "aws_lb" "app-lb"{
  name = "app-internal-lb"
  internal = true	 # true = 내부(internal) / false = 외부(Internet-facing)
  load_balancer_type = "application" # Default - application, 다른 하나는 gateway
  security_groups = [aws_security_group.main-sg.id]
  subnets = [aws_subnet.private_subnet_a.id, aws_subnet.private_subnet_c.id]
##  depends_on = [aws_ami_from_instance.app-layer-AS-template-ami] # AppEC2 완전 생성 후 ALB 생성 시작
  tags = {
      Name = "app-internal-lb"
  }
}


# App Target Groups
resource "aws_lb_target_group" "app-lb-tg"{
  name    = "app-lb-tg"
  port    = "4000"
  protocol   = "HTTP"
  vpc_id  = aws_vpc.main.id
  target_type = "instance"
  
  health_check {
    path = "/health" # 앞서 AppInstance 사전 구축 시, curl로 헬스 체크 테스트했던 경로
    protocol = "HTTP"
    healthy_threshold  = 2 # 헬스 체크 문제 시, 정상 요청 반환이 될때까지의 최대 재요청 수(정상 간주)
    unhealthy_threshold = 2 # 헬스 체크 문제 시, 최대 실패 횟수 Limit
      # 결론은 헬스 체크 제대로 안될 때 최대 2번까지는 시도한다
    interval = 30 # 헬스 체크 인터벌(초)
    timeout = 5 # 해당 시간(초)내 응답이 없으면 실패 간주
  }

  tags = {
      Name = "app-lb-tg"
  }
}

