# sPECIFy the provider and access details
provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.aws_region}"
}
resource "aws_vpc" "t_cr_vpc" {
  # resource configuration
}
# data "aws_subnet_ids" "t_my_subnets" {
#   vpc_id = aws_vpc.t_cr_vpc.id  
#   tags = {
#     Name = "Dev-Private-*"
#   }
# }
# data "aws_subnet" "t_my_subnet_ids" {
#   for_each = data.aws_subnet_ids.t_my_subnets.ids
#   id      = each.value
# }

# output "subnet_ids" {
#   value = [for s in data.aws_subnets.t_my_subnets : s]
# }

## Network
# Create VPC
# module "vpc" {
#   source           = "./network/vpc"
#   eks_cluster_name = "${var.eks_cluster_name}"
#   cidr_block       = "${var.cidr_block}"
# }

# # Create Subnets
# module "subnets" {
#   source           = "./network/subnets"
#   eks_cluster_name = "${var.eks_cluster_name}"
#   vpc_id           = "${module.vpc.vpc_id}"
#   vpc_cidr_block   = "${module.vpc.vpc_cidr_block}"
# }

# Configure Routes
# module "route" {
#   source              = "./network/route"
#   main_route_table_id = "${module.vpc.main_route_table_id}"
#   gw_id               = "${module.vpc.gw_id}"

#   subnets = [
#     "${module.subnets.subnets}",
#   ]
# }

module "eks_iam_roles" {
  source = "./eks/eks_iam_roles"
}


/* fixed*/
module "eks_sec_group" {
  source           = "./eks/eks_sec_group"
  eks_cluster_name = "${var.eks_cluster_name}"
  vpc_id           = "${aws_vpc.t_cr_vpc.id}"
}

/*fixed*/
module "eks_cluster" {
  source           = "./eks/eks_cluster"
  eks_cluster_name = "${var.eks_cluster_name}"
  iam_cluster_arn  = "${module.eks_iam_roles.iam_cluster_arn}"
  iam_node_arn     = "${module.eks_iam_roles.iam_node_arn}"
  #subnets = data.aws_subnet.t_my_subnet_ids
  #subnets = [data.aws_subnets.t_my_subnet_ids["0"],data.aws_subnets.t_my_subnet_ids["1"]]
  #subnets = data.aws_subnet_ids.t_my_subnet_ids
  subnets = [ "subnet-08b5650900599103f", "subnet-0a83b10bdde3ab156"]

  security_group_cluster = "${module.eks_sec_group.security_group_cluster}"
  
}

/* fixed */
module "eks_node" {
  source                    = "./eks/eks_node"
  eks_cluster_name          = "${var.eks_cluster_name}"
  eks_certificate_authority = "${module.eks_cluster.eks_certificate_authority}"
  eks_endpoint              = "${module.eks_cluster.eks_endpoint}"
  iam_instance_profile      = "${module.eks_iam_roles.iam_instance_profile}"
  security_group_node       = "${module.eks_sec_group.security_group_node}"
  #subnets = data.aws_subnet.t_my_subnet_ids
  #subnets = [data.aws_subnets.t_my_subnet_ids["0"],data.aws_subnets.t_my_subnet_ids["1"]]
 # subnets = data.aws_subnet_ids.t_my_subnets
 subnets = [ "subnet-08b5650900599103f", "subnet-0a83b10bdde3ab156"]
  
}
