variable "name" {
    type=string
}

variable "privateKeyPem" {}

variable "certBodyPem" {}

variable "certChain" {
  default = ""
  type=string
}
