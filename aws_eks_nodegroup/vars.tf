variable "name" {
  type = string
}

variable "vpcId" {
  type = string
}

variable "clusterSize" {
  type    = number
  default = 1
}

variable "clusterName" {
  type = string
}

variable "subnetIds" {
  type    = set(string)
  default = []
}

variable "clusterMaxSize" {
  type    = number
  default = 10
}

variable "instanceTypes" {
  type    = set(string)
  default = ["t3a.medium", "t3.medium"]
}

variable "sshKeyName" {
  type = string
}

variable "monitorCreditBalance" {
  type    = bool
  default = true
}

variable "creditBalanceThreshold" {
  type    = number
  default = 10
}

variable "snsTopicArns" {
  type    = set(string)
  default = null
}

variable "k8sVersion" {
  type        = string
  default     = null
  description = "The NG kubernetes version. Should be same or less than 1 version behind the cluster k8s version!"
}

variable "createNodegroup" {
  type    = bool
  default = true
}

variable "bootExtraArgs" {
  type    = string
  default = ""
}

variable "encrypt" {
  type    = bool
  default = true
}

variable "useOwnLaunchTemplate" {
  type    = bool
  default = false
}

variable "diskSize" {
  type    = number
  default = 21
}

variable "clusterDnsIpAddress" {
  type        = string
  description = "the internal kube-dns ip address"
  default     = "10.100.0.10"
}
