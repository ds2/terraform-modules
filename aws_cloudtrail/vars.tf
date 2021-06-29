variable "id" {
  type = string
}

variable "s3LogBucketName" {
  type = string
}

variable "logPrefix" {
  type = string
}

variable "logKmsKeyArn" {
  type = string
}

variable "multiRegion" {
  type    = bool
  default = false
}
