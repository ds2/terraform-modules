resource "aws_iam_role" "k8srole" {
  name_prefix = "${var.clusterName}-eks-role-"
  description = "the IAM role for the eks cluster master"

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
  tags = {
    Name        = var.clusterName
    Terraformed = true
  }
}

resource "aws_iam_role_policy_attachment" "eks-cluster-policy2k8srole" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.k8srole.name
}

resource "aws_iam_role_policy_attachment" "eks-service-policy2k8srole" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.k8srole.name
}

resource "aws_cloudwatch_log_group" "cw" {
  name              = "/aws/eks/${var.clusterName}/cluster"
  retention_in_days = 7
}

data "aws_subnet" "subnets" {
  for_each = var.subnetIds
  id       = each.value
}

# resource "aws_subnet" "changeSubnet" {
#   for_each = data.aws_subnet.subnets
#   vpc_id     = each.value.vpc_id
#   cidr_block = each.value.cidr_block

#   tags = merge(each.value.tags, { "kubernetes.io/cluster/${var.clusterName}" = "shared" })
# }

resource "aws_eks_cluster" "cluster" {
  name     = var.clusterName
  role_arn = aws_iam_role.k8srole.arn
  version  = var.k8sVersion

  vpc_config {
    subnet_ids = var.subnetIds
  }

  enabled_cluster_log_types = var.logTypes

  depends_on = [
    aws_iam_role_policy_attachment.eks-cluster-policy2k8srole,
    aws_iam_role_policy_attachment.eks-service-policy2k8srole,
    aws_cloudwatch_log_group.cw
  ]

  tags = {
    Name        = var.clusterName
    Terraformed = true
  }

  dynamic "encryption_config" {
    for_each = var.kmsKeyArn != null ? [1] : []
    content {
      provider {
        key_arn = var.kmsKeyArn
      }
      resources = ["secrets"]
    }
  }
}


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

resource "aws_security_group_rule" "ngsg_sshinc" {
  security_group_id = aws_security_group.ngsg.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  description       = "SSH remote access incoming"
  cidr_blocks       = ["0.0.0.0/0"]
  protocol          = "TCP"
}

resource "aws_security_group_rule" "ngsg_sshout" {
  security_group_id = aws_security_group.ngsg.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  description       = "SSH remote access outgoing"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  protocol          = "TCP"
}

resource "aws_eks_node_group" "eksng" {
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
  # lifecycle {
  #   create_before_destroy = true
  # }
}

// AutoScalingGroupName
resource "aws_cloudwatch_metric_alarm" "cpucreditbalance" {
  count                     = var.monitorCreditBalance ? 1 : 0
  alarm_name                = "EKS ${var.clusterName} Low CPUCreditBalance"
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUCreditBalance"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = 30
  alarm_description         = "The credit balance for the eks instance from ${var.clusterName} is very low. Please check!"
  insufficient_data_actions = []
  alarm_actions             = var.snsTopicArns
  ok_actions                = var.snsTopicArns
  # treat_missing_data        = var.missingData
  dimensions = {
    AutoScalingGroupName = var.asgName
  }
  tags = {
    Name        = "${var.clusterName} EKS CPU Credit Balance"
    Terraformed = true
  }
}
