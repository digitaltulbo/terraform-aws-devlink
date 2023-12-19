// Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.mainVPC.id
  
  tags = {
    Name = "igw"
  }
}