output "fqdns" {
  value = tolist(aws_route53_record.zonerecord.*.fqdn)
}
