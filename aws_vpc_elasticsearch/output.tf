output "arn" {
  value = aws_elasticsearch_domain.domain.arn
}
output "domain_id" {
  value = aws_elasticsearch_domain.domain.domain_id
}
output "domain_name" {
  value = aws_elasticsearch_domain.domain.domain_name
}
output "endpoint" {
  value = aws_elasticsearch_domain.domain.endpoint
}
output "kibana_endpoint" {
  value = aws_elasticsearch_domain.domain.kibana_endpoint
}
output "cw_loggroup_arn" {
  value = aws_cloudwatch_log_group.loggroup.arn
}
