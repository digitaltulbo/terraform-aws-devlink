// Create public Subnet a,c
resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.194.0.0/24" 
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = true
  tags = {
    "Name" = "public_subnet_a"
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/devlink" = "owned"
  }
}

resource "aws_subnet" "public_subnet_c" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.194.1.0/24"
  availability_zone       = "ap-northeast-2c"
  map_public_ip_on_launch = true
  tags = {
    "Name" = "public_subnet_c"
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/devlink" = "owned"
  }
}
// Create private subnet a,c

resource "aws_subnet" "private_subnet_a" {
  vpc_id                    = aws_vpc.main.id
  cidr_block                = "10.194.100.0/24"
  availability_zone         = "ap-northeast-2a"
  tags = {
    Name = "private_subnet_a"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/devlink" = "owned"
  }
}

resource "aws_subnet" "private_subnet_c" {
  vpc_id                    = aws_vpc.main.id
  cidr_block                = "10.194.101.0/24"
  availability_zone         = "ap-northeast-2c"
  tags = {
    "Name" = "private_subnet_c"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/devlink" = "owned"
  }
}

