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
        "ecr:BatchDeleteImage",
        # "ecr:SetRepositoryPolicy",
        # "ecr:DeleteRepositoryPolicy",
        # "ecr:DeleteRepository"
    ]
}

variable "pullPermissions" {
    type=set(string)
    default=[
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability",
    ]
}