data "aws_route53_zone" "zone" {
  name = var.domain
}

resource "aws_route53_record" "zonerecord" {
  count   = length(var.weights) > 1 ? length(var.weights) : 1
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = var.subdomain
  type    = var.type
  ttl     = var.ttl

  dynamic "weighted_routing_policy" {
    for_each = length(var.weights) > 1 ? [1] : []
    content {
      weight = var.weights[count.index]
    }
  }

  set_identifier = length(var.weights) > 1 ? "${var.subdomain}_${var.domain}_${var.weights[count.index]}" : null
  records        = length(var.weights) > 1 ? [var.records[count.index]] : var.records
}
