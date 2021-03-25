# worker nodes
data "aws_vpc" "vpc" {
  id = var.vpcId
}

data "aws_eks_cluster" "targetCluster" {
  name = var.clusterName
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_iam_role" "workerrole" {
  name_prefix = "${var.name}-worker-role-"

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

resource "aws_subnet" "sn1" {
  count                   = length(var.subnetIds) > 0 ? 0 : length(data.aws_availability_zones.available.names)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = cidrsubnet(data.aws_vpc.vpc.cidr_block, 8, count.index + 5)
  vpc_id                  = data.aws_vpc.vpc.id
  map_public_ip_on_launch = false

  tags = {
    "kubernetes.io/cluster/${var.clusterName}" = "shared"
    Terraformed                                = true
    Name                                       = "${var.name}-worker-sn-${count.index}"
  }
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "aws_security_group" "ngsg" {
  name_prefix = "${var.name}-nodegroup-sg-"
  description = "the security group for the worker nodes for cluster ${var.name}"
  vpc_id      = data.aws_vpc.vpc.id

  tags = {
    Name        = "${var.name} Nodeworker SecurityGroup"
    Terraformed = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "allow-ssh" {
  security_group_id = aws_security_group.ngsg.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  description       = "SSH remote access incoming"
  cidr_blocks       = [data.aws_vpc.vpc.cidr_block]
  ipv6_cidr_blocks  = data.aws_vpc.vpc.ipv6_cidr_block != null ? [data.aws_vpc.vpc.ipv6_cidr_block] : null
  protocol          = "TCP"
}

resource "aws_security_group_rule" "allow-https" {
  description       = "Allow https from all VPC"
  from_port         = 443
  protocol          = "tcp"
  cidr_blocks       = data.aws_vpc.vpc.cidr_block[*]
  ipv6_cidr_blocks  = data.aws_vpc.vpc.ipv6_cidr_block != null ? [data.aws_vpc.vpc.ipv6_cidr_block] : null
  to_port           = 443
  type              = "ingress"
  security_group_id = aws_security_group.ngsg.id
}

resource "aws_security_group_rule" "ngsg-ingress-self" {
  description              = "Allow node to communicate with each other"
  from_port                = 1025
  protocol                 = "-1"
  security_group_id        = aws_security_group.ngsg.id
  source_security_group_id = aws_security_group.ngsg.id
  to_port                  = 65535
  type                     = "ingress"
}

locals {
  clusterSgId = data.aws_eks_cluster.targetCluster.vpc_config[0].cluster_security_group_id
}

resource "aws_security_group_rule" "ngsg-ingress-cluster" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "-1"
  security_group_id        = aws_security_group.ngsg.id
  source_security_group_id = local.clusterSgId
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "demo-cluster-ingress-node-https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ngsg.id
  source_security_group_id = local.clusterSgId
  to_port                  = 443
  type                     = "ingress"
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

resource "aws_security_group_rule" "ngsg_443" {
  security_group_id        = aws_security_group.ngsg.id
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  description              = "Nodes to controlplane"
  source_security_group_id = local.clusterSgId
  protocol                 = "TCP"
}

resource "aws_eks_node_group" "eksng" {
  count           = var.createNodegroup ? 1 : 0
  cluster_name    = var.clusterName
  node_group_name = "${var.name}-worker-ng"
  node_role_arn   = aws_iam_role.workerrole.arn
  subnet_ids      = length(var.subnetIds) > 0 ? var.subnetIds : aws_subnet.sn1[*].id
  ami_type        = var.useOwnLaunchTemplate ? null : "AL2_x86_64"
  disk_size       = var.useOwnLaunchTemplate ? null : var.diskSize
  instance_types  = var.useOwnLaunchTemplate ? null : var.instanceTypes
  version         = var.k8sVersion

  scaling_config {
    desired_size = var.clusterSize
    max_size     = var.clusterMaxSize
    min_size     = 1
  }

  dynamic "launch_template" {
    for_each = aws_launch_template.ngtmpl[*]
    content {
      id      = launch_template.value.id
      version = launch_template.value.latest_version
    }
  }
  dynamic "remote_access" {
    for_each = var.useOwnLaunchTemplate ? [] : [1]
    content {
      ec2_ssh_key = var.sshKeyName
    }
  }

  labels = {
    Name        = "${var.name}-node"
    Terraformed = false
    DoneByAws   = true
  }

  tags = {
    Name        = "${var.name}-worker-ng"
    Terraformed = true
  }
  lifecycle {
    create_before_destroy = false
    ignore_changes        = [scaling_config[0].desired_size, version]
  }

  depends_on = [
    aws_subnet.sn1,
    aws_iam_role_policy_attachment.worker-cni,
    aws_iam_role_policy_attachment.worker-np,
    aws_iam_role_policy_attachment.worker-reg,
    aws_security_group.ngsg
  ]
}

// AutoScalingGroupName
resource "aws_cloudwatch_metric_alarm" "cpucreditbalance" {
  count                     = var.monitorCreditBalance && length(aws_eks_node_group.eksng) > 0 ? 1 : 0
  alarm_name                = "EKS ${var.name} Low CPUCreditBalance"
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUCreditBalance"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = var.creditBalanceThreshold
  alarm_description         = "The credit balance for the eks instance from ${var.name} is very low. Please check!"
  insufficient_data_actions = []
  alarm_actions             = var.snsTopicArns
  ok_actions                = var.snsTopicArns
  # treat_missing_data        = var.missingData
  dimensions = {
    AutoScalingGroupName = aws_eks_node_group.eksng[0].resources[0].autoscaling_groups[0].name
  }

}
