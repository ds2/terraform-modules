data "aws_ami" "eks-image" {
  most_recent = true
  name_regex  = "^amazon-eks-node-${data.aws_eks_cluster.targetCluster.version}"
  owners      = ["amazon"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_launch_template" "ngtmpl" {
  count       = var.useOwnLaunchTemplate ? 1 : 0
  name_prefix = "${var.name}-"
  description = "Dummy launcher template for the eks nodegroup ${var.name}"

  block_device_mappings {
    ebs {
      delete_on_termination = true
      volume_size           = var.diskSize
      encrypted             = var.encrypt
    }
  }

  ebs_optimized = true

  image_id = data.aws_ami.eks-image.id

  instance_type = tolist(var.instanceTypes)[0]

  key_name = var.sshKeyName

  monitoring {
    enabled = true
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.ngsg.id]
    delete_on_termination       = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name                 = var.name
      Terraformed          = false
      "eks:cluster-name"   = data.aws_eks_cluster.targetCluster.name
      "eks:nodegroup-name" = var.name
    }
  }

  tags = {
    Name        = var.name
    Terraformed = true
  }

  user_data = base64encode(templatefile("${path.module}/userdata.sh", {
    ngName               = var.name
    clusterName          = data.aws_eks_cluster.targetCluster.name
    clusterEndpoint      = data.aws_eks_cluster.targetCluster.endpoint
    clusterCaCertificate = data.aws_eks_cluster.targetCluster.certificate_authority[0].data
    clusterDnsIpAddress  = var.clusterDnsIpAddress
    kubelet_extra_args   = "--node-labels=eks.amazonaws.com/nodegroup-image=${data.aws_ami.eks-image.id},eks.amazonaws.com/capacityType=ON_DEMAND,eks.amazonaws.com/nodegroup=${var.name},Terraformed=false,DoneByAws=true,Name=${var.name}-node"
    bootExtraArgs        = var.bootExtraArgs
  }))
}
