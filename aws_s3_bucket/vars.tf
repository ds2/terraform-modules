variable "name" {
  type = string
}

variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "acl" {
  type    = string
  default = "private"
}

variable "versioned" {
  type    = bool
  default = false
}

variable "readonlyIamArn" {
  type        = set(string)
  description = "the ARNs of the users who can only read data from the bucket"
  default     = []
}

variable "adminIamArn" {
  type        = set(string)
  description = "the ARNs of the users who can only read data from the bucket"
  default     = []
}

variable "maxUploadDays" {
  type    = number
  default = 3
}

variable "ncvDays" {
  type    = number
  default = 30
}

variable "ncvExpireDays" {
  type    = number
  default = 60
}

variable "kmsKeyArn" {
  type    = string
  default = null
}

variable "encryptContent" {
  type    = bool
  default = false
}

variable "isWebsite" {
  type    = bool
  default = false
}

variable "websiteIndexFile" {
  type    = string
  default = "index.html"
}

variable "websiteErrorFile" {
  type    = string
  default = "error.html"
}

variable "websiteRedirectAllTo" {
  type    = string
  default = null
}

variable "websiteRoutingRulesJson" {
  type    = string
  default = null
}

variable "adminPermissions" {
  description = "The permissions for all write users"
  type        = set(string)
  default = [
    "s3:GetObject*",
    "s3:PutObject*",
    "s3:DeleteObject*",
    # "s3:GetBucket*",
    # "s3:ListBucket*",
    # "s3:CreateMultipartUpload",
    # "s3:ListMultipartUploadParts",
    # "s3:AbortMultipartUpload"
    # "kms:Encrypt",
    # "kms:Decrypt",
    # "kms:ReEncrypt*",
    # "kms:GenerateDataKey*",
    # "kms:DescribeKey"
  ]
}

variable "readPermissions" {
  type        = set(string)
  description = "the permissions for readonly users"
  default = [
    "s3:GetObject"
  ]
}
