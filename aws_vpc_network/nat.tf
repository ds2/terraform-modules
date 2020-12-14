resource "aws_eip" "nat" {
  count = var.enableNatGateway ? 1 : 0
  vpc   = true
  lifecycle { create_before_destroy = true }
  tags = {
    Name        = var.name
    Terraformed = true
  }
}
