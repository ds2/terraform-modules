variable "name" {
    type=string
}

variable "tagMutable" {
    type=bool
    default=true
}

variable "deleteUntaggedAfterDays" {
    type=number
    default=14
}

variable "keepTagsCount" {
    type=number
    default=30
}

variable "tagPrefixes" {
    type=set(string)
    default=["v"]
}

variable "pushArns" {
    type=set(string)
    default=null
}

variable "pullArns" {
    type=set(string)
    default=null
}

variable "publicPull" {
    type=bool
    default=false
}

variable "pushPermissions" {
    type=set(string)
    default=[
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetRepositoryPolicy",
        "ecr:DescribeRepositories",
        "ecr:ListImages",
        "ecr:DescribeImages",
        "ecr:BatchGetImage",
        "ecr:GetLifecyclePolicy",
        "ecr:GetLifecyclePolicyPreview",
        "ecr:ListTagsForResource",
        "ecr:DescribeImageScanFindings",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload",
        "ecr:PutImage"
    ]
}

variable "pullPermissions" {
    type=set(string)
    default=[
        "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:GetRepositoryPolicy",
                "ecr:DescribeRepositories",
                "ecr:ListImages",
                "ecr:DescribeImages",
                "ecr:BatchGetImage",
                "ecr:GetLifecyclePolicy",
                "ecr:GetLifecyclePolicyPreview",
                "ecr:ListTagsForResource",
                "ecr:DescribeImageScanFindings"
    ]
}

variable "scanOnPush" {
    type=bool
    default=true
}