resource "aws_eks_cluster" "terra" {
  name     = "${var.eks_cluster_name}"
  role_arn = "${var.iam_cluster_arn}"
  enabled_cluster_log_types = ["audit", "api", "authenticator","scheduler","controllerManager"]
   
  vpc_config {
    security_group_ids = ["${var.security_group_cluster}"]
    subnet_ids         = "${var.subnets}"
     endpoint_private_access = true
     endpoint_public_access  = false
  }

  }