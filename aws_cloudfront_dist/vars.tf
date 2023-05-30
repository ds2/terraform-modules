variable "name" {
  type = string
}

variable "comment" {
  type = string
}

variable "ipv6Enabled" {
  type    = bool
  default = true
}

variable "priceClass" {
  type    = string
  default = "PriceClass_All"
}
