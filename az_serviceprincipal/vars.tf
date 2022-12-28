variable "name" {
  type        = string
  description = "The principal name, also the app name"
}

variable "description" {
  type        = string
  description = "The description of the Service Principal"
  default     = null
}

variable "pwRotationDays" {
  type    = number
  default = 14
}
