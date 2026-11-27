resource "openstack_networking_secgroup_v2" "k8s" {
  name = "${var.prefix}-secgroup"
}

resource "openstack_networking_secgroup_rule_v2" "intra" {
  direction         = "ingress"
  ethertype         = "IPv4"
  remote_group_id   = openstack_networking_secgroup_v2.k8s.id
  security_group_id = openstack_networking_secgroup_v2.k8s.id
}

resource "openstack_networking_secgroup_rule_v2" "icmp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = var.admin_cidr
  security_group_id = openstack_networking_secgroup_v2.k8s.id
}

resource "openstack_networking_secgroup_rule_v2" "tcp" {
  for_each          = toset(["22", "6443", "80", "443"])
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = tonumber(each.value)
  port_range_max    = tonumber(each.value)
  remote_ip_prefix  = var.admin_cidr
  security_group_id = openstack_networking_secgroup_v2.k8s.id
}
