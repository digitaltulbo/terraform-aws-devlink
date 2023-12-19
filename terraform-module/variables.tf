# variables.tf
variable "region" {
  default = "ap-northeast-2"
}

variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type = list(string)
  default = ["ap-northeast-2a", "ap-northeast-2c"]
}

variable "cluster_name" {
  description = "Cluster Name"
  type = string
  default = null
}

variable "cluster_version" {
  description = "Cluster Version"
  type = string
  default = null
}

variable "vpc_cidr" {
  description = "VPC CIDR Range"
  type = string
  default = null
}

variable "vpc_name" {
  description = "VPC Name"
  type = string
  default = null
}

# terraform.auto.tfvars
vpc_name     = "main-vpc"
vpc_cidr     = "192.168.0.0/16"

cluster_name     = "cluster-1"
cluster_version  = "1.27"