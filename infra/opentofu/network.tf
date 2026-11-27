data "openstack_networking_network_v2" "external" {
  name = "external"
}

resource "openstack_networking_network_v2" "nodes" {
  name = "${var.prefix}-net"
}

resource "openstack_networking_subnet_v2" "nodes" {
  name            = "${var.prefix}-subnet"
  network_id      = openstack_networking_network_v2.nodes.id
  cidr            = var.nodes_cidr
  gateway_ip      = cidrhost(var.nodes_cidr, 1)
  dns_nameservers = var.dns_servers

  allocation_pool {
    start = cidrhost(var.nodes_cidr, 50)
    end   = cidrhost(var.nodes_cidr, 99)
  }
}

resource "openstack_networking_router_v2" "nodes" {
  name                = "${var.prefix}-router"
  external_network_id = data.openstack_networking_network_v2.external.id
}

resource "openstack_networking_router_interface_v2" "nodes" {
  router_id = openstack_networking_router_v2.nodes.id
  subnet_id = openstack_networking_subnet_v2.nodes.id
}
