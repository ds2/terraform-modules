resource "aws_key_pair" "keypair" {
  key_name_prefix = var.name
  public_key      = var.publicKey
  tags = {
    Name        = var.name
    Terraformed = true
  }
  lifecycle {
    create_before_destroy = true
  }
}
