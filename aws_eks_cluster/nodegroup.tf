# worker nodes
resource "aws_iam_role" "workerrole" {
  name_prefix = "${var.clusterName}-worker-role-"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "worker-np" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.workerrole.name
}

resource "aws_iam_role_policy_attachment" "worker-cni" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.workerrole.name
}

resource "aws_iam_role_policy_attachment" "worker-reg" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.workerrole.name
}

resource "aws_security_group" "ngsg" {
  name_prefix = "${var.clusterName}-nodegroup-sg-"
  description = "the security group for the worker nodes for cluster ${var.clusterName}"
  vpc_id      = var.vpcId

  tags = {
    Name        = "${var.clusterName} Nodeworker SecurityGroup"
    Terraformed = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_vpc" "vpc" {
  id = var.vpcId
}

resource "aws_security_group_rule" "ngsg_sshinc" {
  security_group_id = aws_security_group.ngsg.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  description       = "SSH remote access incoming"
  cidr_blocks       = [data.aws_vpc.vpc.cidr_block]
  ipv6_cidr_blocks  = data.aws_vpc.vpc.ipv6_cidr_block != null ? [data.aws_vpc.vpc.ipv6_cidr_block] : null
  protocol          = "TCP"
}

resource "aws_security_group_rule" "ngsg_sshout" {
  security_group_id = aws_security_group.ngsg.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  description       = "all directions"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  protocol          = "TCP"
}

resource "aws_eks_node_group" "eksng" {
  count           = var.clusterSize > 0 ? 1 : 0
  ami_type        = "AL2_x86_64"
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "${var.clusterName}-worker-ng"
  node_role_arn   = aws_iam_role.workerrole.arn
  subnet_ids      = var.subnetIds
  disk_size       = "20"
  instance_types  = var.instanceType

  scaling_config {
    desired_size = var.clusterSize
    max_size     = var.clusterMaxSize
    min_size     = 1
  }

  labels = {
    Name        = "${var.clusterName}-node"
    Terraformed = false
    DoneByAws   = true
  }

  tags = {
    Name        = "${var.clusterName}-worker-ng"
    Terraformed = true
  }

  remote_access {
    ec2_ssh_key               = var.sshKeyName
    source_security_group_ids = [aws_security_group.ngsg.id]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.worker-cni,
    aws_iam_role_policy_attachment.worker-np,
    aws_iam_role_policy_attachment.worker-reg,
    aws_eks_cluster.cluster,
    aws_security_group.ngsg
  ]
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}

module "monitoring" {
  source                 = "../aws_instance_alerts"
  name                   = "EKS NG ${var.clusterName}"
  monitorCreditBalance   = var.monitorCreditBalance
  creditBalanceThreshold = var.creditBalanceThreshold
  snsTopicArns           = var.snsTopicArns
  dimensions = {
    AutoScalingGroupName = aws_eks_node_group.eksng[0].resources[0].autoscaling_groups[0].name
  }
}