resource "aws_vpc" "mainVPC" {
  cidr_block = "10.10.0.0/16"

  tags = {
    Name = "main"
  }
}