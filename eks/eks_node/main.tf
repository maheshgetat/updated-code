# data "aws_ami" "eks-worker" {
#   filter {
#     name   = "name"
#     values = ["ami-01ced323515f177b0"]
#   }
#   most_recent = true
# }

data "aws_region" "current" {}

# data "template_file" "user_data" {
#   template = "${file("${path.module}/userdata.tpl")}"

#   vars = {
#     eks_certificate_authority = "${var.eks_certificate_authority}"
#     eks_endpoint              = "${var.eks_endpoint}"
#     eks_cluster_name          = "${var.eks_cluster_name}"
# 		#workspace 								= "${terraform.workspace}"
#     aws_region_current_name 	= "${data.aws_region.current.name}"
#   }
# }
# resource "null_resource" "export_rendered_template" {
# 	provisioner "local-exec" {
# 	command = "cat > /data_output.sh <<EOL\n${data.template_file.user_data.rendered}\nEOL"
#  	}
#  }

 resource "aws_launch_configuration" "terra" {
    associate_public_ip_address = false
   iam_instance_profile        = "${var.iam_instance_profile}"
   image_id                    = "ami-01ced323515f177b0"
   instance_type               = "t3a.small"
    root_block_device {
     delete_on_termination = true
     encrypted             = true
     volume_size           = 20
   }

   name_prefix                 = "eks-node"
   security_groups             = ["${var.security_group_node}"]
 #	user_data 									= "${data.template_file.user_data.rendered}"
  lifecycle {
     create_before_destroy = true
   }
 }

 resource "aws_autoscaling_group" "terra" {
   desired_capacity     = 2
   launch_configuration = "${aws_launch_configuration.terra.id}"
   max_size             = 2
   min_size             = 2
   name                 = "eks-nodes"
   vpc_zone_identifier  = "${var.subnets}"

   tag {
     key                 = "Name"
     value               = "eks-nodes"
     propagate_at_launch = true
   }

   tag {
     key                 = "kubernetes.io/cluster/${var.eks_cluster_name}-${terraform.workspace}"
     value               = "owned"
     propagate_at_launch = true
   }
 }
