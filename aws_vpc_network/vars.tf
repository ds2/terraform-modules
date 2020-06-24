variable "name" {
  type = string
}

variable "cidr" {
  type = string
}

variable "enableIpv6" {
  type    = bool
  default = true
}

variable "enableNatGateway" {
  type    = bool
  default = true
}

# variable "privateSubnetCidr" {
#   type = string
# }

# variable "publicSubnetCidr" {
#   type = string
# }

variable "availZones" {
  type = list(string)
}
