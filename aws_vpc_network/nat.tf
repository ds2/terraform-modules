resource "aws_eip" "nat" {
  vpc = true
  lifecycle { create_before_destroy = true }
  tags = {
    Name        = var.name
    Terraformed = true
  }
}
