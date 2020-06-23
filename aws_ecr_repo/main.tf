resource "aws_ecr_repository" "repo"{
name                 = var.name
  image_tag_mutability = var.tagMutable?"MUTABLE":"IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
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

resource "aws_ecr_repository_policy" "accesspolicy" {
  repository = aws_ecr_repository.repo.name

  policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "new policy",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "ecr:BatchCheckLayerAvailability",
                "ecr:PutImage",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload",
                "ecr:DescribeRepositories",
                "ecr:GetRepositoryPolicy",
                "ecr:ListImages",
                "ecr:DeleteRepository",
                "ecr:BatchDeleteImage",
                "ecr:SetRepositoryPolicy",
                "ecr:DeleteRepositoryPolicy"
            ]
        }
    ]
}
EOF
}