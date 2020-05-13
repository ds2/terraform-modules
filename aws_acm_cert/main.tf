# use US-EAST-1 as region to allow the cert for Cloudfront as well

resource "aws_acm_certificate" "cert" {
  private_key       = var.privateKeyPem
  certificate_body  = var.certBodyPem
  certificate_chain = var.certChain

  tags = {
    Environment = "production"
    Terraformed = "true"
    Name        = var.name
  }

  lifecycle {
    create_before_destroy = true
  }
}
