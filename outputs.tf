output "vpc_id" {
  value = aws_vpc.t_cr_vpc.id
}

output "vpc_cidr_block" {
  value = aws_vpc.t_cr_vpc.cidr_block
}

output "main_route_table_id" {
  value = aws_vpc.t_cr_vpc.main_route_table_id
}

output "vpc_dhcp_id" {
  value = aws_vpc.t_cr_vpc.dhcp_options_id
}
# output "subnets" {
#   value = data.aws_subnets.t_my_subnets.ids
# }

output "route_id" {
  value = aws_vpc.t_cr_vpc.main_route_table_id
}

output "security_group_cluster" {
  value = module.eks_sec_group.security_group_cluster
}

output "security_group_node" {
  value = module.eks_sec_group.security_group_node
}

output "iam_instance_profile" {
  value = module.eks_iam_roles.iam_instance_profile
}

output "iam_cluster_arn" {
  value = module.eks_iam_roles.iam_cluster_arn
}

output "iam_node_arn" {
  value = module.eks_iam_roles.iam_node_arn
}

output "config_map_aws_auth" {
  value = module.eks_cluster.config_map_aws_auth
}

output "kubeconfig" {
  value = module.eks_cluster.kubeconfig
}

output "eks_certificate_authority" {
  value = module.eks_cluster.eks_certificate_authority
}

output "eks_endpoint" {
  value = module.eks_cluster.eks_endpoint
}

output "eks_cluster_name" {
  value = module.eks_cluster.eks_cluster_name
}

