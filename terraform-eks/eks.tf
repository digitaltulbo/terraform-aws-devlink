resource "aws_iam_role" "devlink" {
    name = "eks-cluster-devlink"

    assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
          "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY  
}

resource "aws_iam_role_policy_attachment" "devlink-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.devlink.name
}

resource "aws_eks_cluster" "devlink" {
  name     = "devlink"
  role_arn = aws_iam_role.devlink.arn
    
  vpc_config {
    subnet_ids = [
        aws_subnet.public_subnet_a.id,
        aws_subnet.public_subnet_c.id,
        aws_subnet.private_subnet_a.id,
        aws_subnet.private_subnet_c.id,
    ]
  }
  depends_on = [ aws_iam_role_policy_attachment.devlink-AmazonEKSClusterPolicy ] 
}