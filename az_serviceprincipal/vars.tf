variable "name" {
  type        = string
  description = "The principal name, also the app name"
}

variable "description" {
  type        = string
  description = "The description of the Service Principal"
}

variable "pwRotationDays" {
  type    = number
  default = 14
}
