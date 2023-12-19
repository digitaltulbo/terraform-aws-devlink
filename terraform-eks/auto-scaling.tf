# EC2 Key Pair
resource "tls_private_key" "rsa_4096" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

variable "key_name" {
  type        = string
  default     = "digitaltulbo_key"
  description = "pem file"
}

resource "aws_key_pair" "key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.rsa_4096.public_key_openssh
}

resource "local_file" "private_key" {
  content  = tls_private_key.rsa_4096.private_key_pem
  filename = var.key_name
}

# Web EC2 Instance Launch Template
resource "aws_launch_template" "web_launch_template" {
  name          = "web_launch_template"
  image_id      = "ami-086cae3329a3f7d75" # 인스턴스 이미지
  instance_type = "t2.micro"              # 인스턴스 타입
  
  key_name = aws_key_pair.key_pair.key_name

  user_data = filebase64("${path.module}/server.sh")

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.mainVPC-sg.id]
  }
}

# Web Auto Scaling Group
resource "aws_autoscaling_group" "web_asg" {
  name                = "web-asg"
  min_size            = 2
  max_size            = 2
  desired_capacity    = 2
  target_group_arns   = [aws_lb_target_group.web_lb_tg.arn]
  vpc_zone_identifier = [aws_subnet.public_web_a.id, aws_subnet.public_web_c.id]

  launch_template {
    id      = aws_launch_template.web_launch_template.id
    version = "$Latest"
  }
}

# App EC2 Instance Launch Template
resource "aws_launch_template" "app_launch_template" {
  name          = "app_launch_template"
  image_id      = "ami-086cae3329a3f7d75" # 인스턴스 이미지
  instance_type = "t2.micro"              # 인스턴스 타입
  key_name      = aws_key_pair.key_pair.key_name

  user_data = filebase64("${path.module}/server.sh")

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.groomVPC-sg.id]
  }
}

# App Auto Scaling Group
resource "aws_autoscaling_group" "app_asg" {
  name                = "app-asg"
  min_size            = 2
  max_size            = 2
  desired_capacity    = 2
  target_group_arns   = [aws_lb_target_group.app_lb_tg.arn]
  vpc_zone_identifier = [aws_subnet.private_app_a.id, aws_subnet.private_app_c.id]

  launch_template {
    id      = aws_launch_template.app_launch_template.id
    version = "$Latest"
  }
}