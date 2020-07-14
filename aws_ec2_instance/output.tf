output "arn" {
  value = aws_instance.instance.arn
}
output "id" {
  value = aws_instance.instance.id
}
output "public_dns" {
  value = aws_instance.instance.public_dns
}
output "public_ip" {
  value = aws_instance.instance.public_ip
}
output "ipv6_addresses" {
  value = aws_instance.instance.ipv6_addresses
}
output "private_dns" {
  value = aws_instance.instance.private_dns
}
output "private_ip" {
  value = aws_instance.instance.private_ip
}
