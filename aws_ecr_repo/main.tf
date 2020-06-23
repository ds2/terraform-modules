resource "aws_ecr_repository" "repo"{
name                 = var.name
  image_tag_mutability = var.tagMutable?"MUTABLE":"IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = var.scanOnPush
  }

  tags={
      Name=var.name
      Terraformed=true
  }
}

data "template_file" "untagged" {
  template = file("${path.module}/untagged.json.tpl")
  vars = {
    NUM_DAYS = var.deleteUntaggedAfterDays
  }
}
data "template_file" "tagged" {
  template = file("${path.module}/keeplast.json.tpl")
  vars = {
    NUM_COUNT = var.keepTagsCount
    PREFIXES=jsonencode(var.tagPrefixes)
  }
}

locals {
  taggedStr=var.deleteUntaggedAfterDays>0?data.template_file.untagged.rendered:""
  taggedStr2=var.keepTagsCount>0?data.template_file.tagged.rendered:""
  c1=compact([local.taggedStr, local.taggedStr2])

}

resource "aws_ecr_lifecycle_policy" "lifetimepolicy" {
  repository = aws_ecr_repository.repo.name

  policy = <<EOF
{
    "rules": [
        ${join(",",local.c1)}
    ]
}
EOF
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "accesspolicydocument" {
  statement {
    sid = "push1"
    effect  = "Allow"
    actions = var.pushPermissions
    # resources = [aws_ecr_repository.repo.arn]
    principals {
      type = "AWS"
      identifiers = compact(coalesce(
          var.pushArns,
          [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
        data.aws_caller_identity.current.arn
      ]
        ))
    }
  }

  statement {
    sid = "pull1"
    effect  = "Allow"
    actions = var.pullPermissions
    dynamic "principals" {
      for_each=var.publicPull?[]:[1]
      content {
          type = "AWS"
        identifiers = compact(coalesce(
            var.pullArns,
            [
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
            data.aws_caller_identity.current.arn
          ]
            ))
      }
    }
  }
}


resource "aws_ecr_repository_policy" "accesspolicy" {
  repository = aws_ecr_repository.repo.name

  policy = data.aws_iam_policy_document.accesspolicydocument.json
}