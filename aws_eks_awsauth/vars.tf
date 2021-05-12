variable "clusterName" {
  type = string
}

variable "addAwsAuth" {
  type    = bool
  default = true
}

variable "admGroupArns" {
  type    = set(string)
  default = []
}

variable "admUserArns" {
  type    = set(string)
  default = null
}

variable "admRoleArns" {
  type        = set(string)
  default     = []
  description = "this is the list of roles that can access the eks controlplane. Usually this is the nodegroup arn"
}

variable "cmName" {
  type    = string
  default = "aws-auth"
}