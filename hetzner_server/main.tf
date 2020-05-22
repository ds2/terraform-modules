resource "hcloud_server" "server" {
  name        = var.name
  image       = var.image
  server_type = var.serverType
  datacenter  = var.datacenterName
  labels = {
    Name        = var.name
    Terraformed = true
  }
  ssh_keys  = var.sshKeyIds
  keep_disk = false
}

resource "hcloud_server_network" "nwassign" {
  server_id  = hcloud_server.server.id
  network_id = var.networkId
  ip         = var.ipAddress
  alias_ips  = var.ipAddressAliases
}
