output "vpc_arn" {
  value = aws_vpc.vpc.arn
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "id" {
  value = aws_vpc.vpc.id
}

output "ipv6_cidr" {
  value = aws_vpc.vpc.ipv6_cidr_block
}

# output "private_subnet_ids" {
#   value=join(",", aws_subnet.private.*.id)
# }

output "private_subnet_ids" {
  value = concat(aws_subnet.private.*.id)
}
output "public_subnet_ids" {
  value = concat(aws_subnet.public.*.id)
}

# output "private_subnet_arns" {
#   value=join(",", aws_subnet.private.*.arn)
# }

output "private_subnet_arns" {
  value = concat(aws_subnet.private.*.arn)
}

output "public_subnet_arns" {
  value = concat(aws_subnet.public.*.arn)
}
