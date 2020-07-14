output "private_ip" {
  value = "${aws_instance.instance.private_ip}"
}

output "arn" {
  value = "${aws_instance.instance.arn}"
}
