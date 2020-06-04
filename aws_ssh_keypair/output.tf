output "name" {
  value = aws_key_pair.keypair.key_name
}
output "id" {
  value = aws_key_pair.keypair.key_pair_id
}
output "fingerprint" {
  value = aws_key_pair.keypair.fingerprint
}
