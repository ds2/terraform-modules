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

module "loggroup" {
  source        = "../aws_cloudwatch_loggroup"
  name          = "/aws/eks/${var.clusterName}/cluster"
  retentionDays = var.logRetentionDays
  kmsKeyArn     = var.kmsKeyArn
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
    subnet_ids             = var.subnetIds
    endpoint_public_access = true
    # endpoint_private_access = true
    //public_access_cidrs = ["0.0.0.0/0"]
  }

  enabled_cluster_log_types = var.logTypes

  depends_on = [
    aws_iam_role_policy_attachment.eks-cluster-policy2k8srole,
    aws_iam_role_policy_attachment.eks-service-policy2k8srole,
    module.loggroup
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

resource "aws_iam_openid_connect_provider" "oid" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = []
  url             = aws_eks_cluster.cluster.identity.0.oidc.0.issuer
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "oidpolicy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.oid.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-node"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.oid.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "oidrole" {
  assume_role_policy = data.aws_iam_policy_document.oidpolicy.json
  name_prefix        = "${var.clusterName}-oid-role-"
}
