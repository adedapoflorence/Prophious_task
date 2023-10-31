variable "cluster_name" {
  default = "eks-project-cluster"
  type    = string
}

data "aws_availability_zones" "available" {
  state = "available"
}
