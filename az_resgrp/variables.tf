variable "id" {
  type = string
}

variable "location" {
  type    = string
  default = "Westeuropa"
}

variable "additionalTags" {
  type    = map(string)
  default = {}
}
