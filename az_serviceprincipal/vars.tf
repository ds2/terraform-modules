variable "appName" {
  type        = string
  description = "The name of the application for this principal"
}

variable "description" {
  type        = string
  description = "The description of the Service Principal"
}

variable "pwRotationDays" {
  type    = number
  default = 14
}
