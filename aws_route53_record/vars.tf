variable "domain" {
  type = string
}

variable "subdomain" {
  type = string
}

variable "ttl" {
  type    = number
  default = 60
}

variable "type" {
  type    = string
  default = "CNAME"
}

variable "records" {
  type = list(string)
}

variable "weights" {
  type    = list(number)
  default = []
}
