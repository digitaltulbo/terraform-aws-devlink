data "aws_caller_identity" "current" {}

locals {
  node_group_name        = "${var.cluster_name}-node-group"
  iam_role_policy_prefix = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy"
}

module "eks" {
  # 모듈 사용
  source = "terraform-aws-modules/eks/aws"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets
  
  #관리형 노드 그룹 사용 (기본 설정)
  eks_managed_node_group_defaults = {
    disk_size = 50
  }
  
  
  # 관리형 노드 그룹 사용 (노드별 추가 설정)
  eks_managed_node_groups = {
    general = {
      desired_size = 1
      min_size     = 1
      max_size     = 10

      labels = {
        role = "general"
      }

      instance_types = ["t3.small"]
      capacity_type  = "ON_DEMAND"
    }

    spot = {
      desired_size = 1
      min_size     = 1
      max_size     = 10

      labels = {
        role = "spot"
      }

      instance_types = ["t3.micro"]
      capacity_type  = "SPOT"
    }
  }

  # manage_aws_auth_configmap = true 이것때문에 자꾸 오류남..
  
  # aws_auth_roles = [
  #   {
  #     rolearn  = module.eks_admins_iam_role.iam_role_arn
  #     username = module.eks_admins_iam_role.iam_role_name
  #     groups   = ["system:masters"]
  #   },
  # ]


  tags = {
    "k8s.io/cluster-autoscaler/enabled" : "true"
    "k8s.io/cluster-autoscaler/${var.cluster_name}" : "true"  }
}

#   # 관리형 노드 그룹 사용 (기본 설정)
#   eks_managed_node_group_defaults = {
#     ami_type               = "AL2_x86_64" # 
#     disk_size              = 10           # EBS 사이즈
#     instance_types         = ["t2.small"]
#     # vpc_security_group_ids = [aws_security_group.additional.id]
#     vpc_security_group_ids = []
		
# 		# cluster-autoscaler에 사용 될 IAM 등록
#     iam_role_additional_policies = ["${local.iam_role_policy_prefix}/${module.iam_policy_autoscaling.name}"]
#   }

#   # 관리형 노드 그룹 사용 (노드별 추가 설정)
#   eks_managed_node_groups = {
#     ("${var.cluster_name}-node-group") = {
#       # node group 스케일링
#       min_size     = 1 # 최소
#       max_size     = 3 # 최대
#       desired_size = 2 # 기본 유지

#       # 생성된 node에 labels 추가 (kubectl get nodes --show-labels로 확인 가능)
#       labels = {
#         ondemand = "true"
#       }

#       # 생성되는 인스턴스에 tag추가
#     }
#   }
# }