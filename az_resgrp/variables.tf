variable "id" {
  type = string
}

variable "location" {
  type    = string
  default = "germanywestcentral"
}

variable "additionalTags" {
  type    = map(string)
  default = {}
}
