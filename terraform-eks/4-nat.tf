// Create nat gateway
resource "aws_eip" "nat_ip" {
  vpc = true
  
  tags = {
    Name = "NAT_IP"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnet_a.id

  tags = {
    Name ="NAT_Gateway"
  }

  depends_on = [ aws_internet_gateway.igw ]
}
