resource "aws_iam_role" "k8srole" {
  name = "${var.clusterName}-eks-role"

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
}

resource "aws_iam_role_policy_attachment" "eks-cluster-policy2k8srole" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.k8srole.name
}

resource "aws_iam_role_policy_attachment" "eks-service-policy2k8srole" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.k8srole.name
}

resource "aws_cloudwatch_log_group" "loggroup" {
  name              = "/aws/eks/${var.clustername}/cluster"
  retention_in_days = 365
  kms_key_id        = var.kmsKeyArn
  tags = {
    Name        = var.name
    Terraformed = true
  }
}

resource "aws_eks_cluster" "cluster" {
  name     = var.clustername
  role_arn = aws_iam_role.k8srole.arn

  vpc_config {
    subnet_ids = var.subnetIds
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks-cluster-policy2k8srole,
    aws_iam_role_policy_attachment.eks-service-policy2k8srole,
  ]
}


# worker nodes
resource "aws_iam_role" "workerrole" {
  name = "${var.clusterName}-worker-role"

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




resource "aws_eks_node_group" "eksng" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "${var.clusterName}-worker-ng"
  node_role_arn   = aws_iam_role.workerrole.arn
  subnet_ids      = var.subnetIds
  disk_size       = "20"

  scaling_config {
    desired_size = var.clusterSize
    max_size     = var.clusterMaxSize
    min_size     = 1
  }

  remote_access {
    ec2_ssh_key = var.sshKeyName
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.worker-cni,
    aws_iam_role_policy_attachment.worker-np,
    aws_iam_role_policy_attachment.worker-reg,
  ]
}
