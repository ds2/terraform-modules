variable "name" {
    type=string
}

variable "image" {
    type=string
    default="centos-8"
}

variable "serverType" {
    type=string
    default="cx21"
}

variable "datacenterName" {
    type=string
}

variable "sshKeyIds" {
    type=set(string)
}

variable "networkId" {
    type=string
}

variable "ipAddress" {
    type=string
}
variable "ipAddressAliases" {
    type=set(string)
}
