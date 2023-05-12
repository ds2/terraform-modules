variable "name" {
  type        = string
  description = "the id of the website"
}
variable "resourceGroupName" {
  type        = string
  description = "the name of the resourcegroup to add this website to."
}

variable "location" {
  type    = string
  default = "westeurope"
}

variable "skuTier" {
  type    = string
  default = "Free"
}

variable "skuSize" {
  type    = string
  default = "Free"
}
variable "additionalTags" {
  type        = map(string)
  default     = {}
  description = "Some additional tags to add"
}
