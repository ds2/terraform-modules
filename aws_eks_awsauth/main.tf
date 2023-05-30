data "aws_eks_cluster" "cluster" {
  name = var.clusterName
}

data "aws_caller_identity" "current" {}

data "aws_eks_cluster_auth" "cluster" {
  name = var.clusterName
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}


resource "null_resource" "wait_for_cluster" {
  count = var.addAwsAuth ? 1 : 0

  depends_on = [
    data.aws_eks_cluster.cluster,
    # aws_security_group_rule.cluster_private_access,
  ]

  provisioner "local-exec" {
    # credit: https://github.com/terraform-aws-modules/terraform-aws-eks
    command     = "for i in `seq 1 60`; do if `command -v wget > /dev/null`; then wget --no-check-certificate -O - -q $ENDPOINT/healthz >/dev/null && exit 0 || true; else curl -k -s $ENDPOINT/healthz >/dev/null && exit 0 || true;fi; sleep 5; done; echo TIMEOUT && exit 1"
    interpreter = ["/bin/sh", "-c"]
    environment = {
      ENDPOINT = data.aws_eks_cluster.cluster.endpoint
    }
  }
}

resource "kubernetes_config_map" "aws_auth" {
  count      = var.addAwsAuth ? 1 : 0
  depends_on = [null_resource.wait_for_cluster[0]]

  metadata {
    name      = var.cmName
    namespace = "kube-system"
    labels = merge(
      {
        "app.kubernetes.io/managed-by" = "Terraform"
        # / are replaced by . because label validator fails in this lib
        # https://github.com/kubernetes/apimachinery/blob/1bdd76d09076d4dc0362456e59c8f551f5f24a72/pkg/util/validation/validation.go#L166
        "terraform.io/module" = "terraform-aws-modules.eks.aws"
        Terraformed           = true
      },
      # var.aws_auth_additional_labels
    )
  }

  data = {
    mapRoles = templatefile("${path.module}/aws-auth-roles.yaml.tpl", {
      roleArns = var.admRoleArns
    })
    mapUsers = templatefile("${path.module}/aws-auth-users.yaml.tpl", {
      userArns = compact(coalesce(
        var.admUserArns,
        [
          "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
          data.aws_caller_identity.current.arn
        ]
      ))
      admUser = "admin"
    })
    # mapAccounts = yamlencode(var.map_accounts)
  }
}
