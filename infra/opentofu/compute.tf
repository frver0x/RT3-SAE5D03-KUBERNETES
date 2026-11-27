locals {
  vip_ip = cidrhost(var.nodes_cidr, 101)
}

resource "openstack_compute_keypair_v2" "admin" {
  name       = "${var.prefix}-key"
  public_key = file(pathexpand(var.ssh_public_key_path))
}

resource "openstack_compute_servergroup_v2" "cp" {
  name     = "${var.prefix}-cp"
  policies = ["soft-anti-affinity"]
}

resource "openstack_compute_servergroup_v2" "worker" {
  name     = "${var.prefix}-worker"
  policies = ["soft-anti-affinity"]
}

resource "openstack_networking_port_v2" "vip" {
  name               = "${var.prefix}-api-vip"
  network_id         = openstack_networking_network_v2.nodes.id
  security_group_ids = [openstack_networking_secgroup_v2.k8s.id]
  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.nodes.id
    ip_address = local.vip_ip
  }
}

resource "openstack_networking_port_v2" "cp" {
  count              = var.cp_count
  name               = "${var.prefix}-cp-${count.index + 1}"
  network_id         = openstack_networking_network_v2.nodes.id
  security_group_ids = [openstack_networking_secgroup_v2.k8s.id]
  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.nodes.id
    ip_address = cidrhost(var.nodes_cidr, 11 + count.index)
  }
  allowed_address_pairs {
    ip_address = local.vip_ip
  }
  allowed_address_pairs {
    ip_address = var.metallb_cidr
  }
}

resource "openstack_networking_port_v2" "worker" {
  count              = var.worker_count
  name               = "${var.prefix}-worker-${count.index + 1}"
  network_id         = openstack_networking_network_v2.nodes.id
  security_group_ids = [openstack_networking_secgroup_v2.k8s.id]
  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.nodes.id
    ip_address = cidrhost(var.nodes_cidr, 21 + count.index)
  }
  allowed_address_pairs {
    ip_address = var.metallb_cidr
  }
}

resource "openstack_compute_instance_v2" "cp" {
  count       = var.cp_count
  name        = "${var.prefix}-cp-${count.index + 1}"
  image_id    = var.image_id
  flavor_name = var.cp_flavor
  key_pair    = openstack_compute_keypair_v2.admin.name
  user_data   = "#cloud-config\n${yamlencode({ ssh_authorized_keys = var.team_ssh_keys })}"
  network {
    port = openstack_networking_port_v2.cp[count.index].id
  }
  scheduler_hints {
    group = openstack_compute_servergroup_v2.cp.id
  }
}

resource "openstack_compute_instance_v2" "worker" {
  count       = var.worker_count
  name        = "${var.prefix}-worker-${count.index + 1}"
  image_id    = var.image_id
  flavor_name = var.worker_flavor
  key_pair    = openstack_compute_keypair_v2.admin.name
  user_data   = "#cloud-config\n${yamlencode({ ssh_authorized_keys = var.team_ssh_keys })}"
  network {
    port = openstack_networking_port_v2.worker[count.index].id
  }
  scheduler_hints {
    group = openstack_compute_servergroup_v2.worker.id
  }
}

resource "openstack_blockstorage_volume_v3" "ceph" {
  count = var.worker_count
  name  = "${var.prefix}-worker-${count.index + 1}-ceph"
  size  = var.ceph_disk_size
}

resource "openstack_compute_volume_attach_v2" "ceph" {
  count       = var.worker_count
  instance_id = openstack_compute_instance_v2.worker[count.index].id
  volume_id   = openstack_blockstorage_volume_v3.ceph[count.index].id
}

resource "openstack_networking_floatingip_v2" "vip" {
  pool       = data.openstack_networking_network_v2.external.name
  port_id    = openstack_networking_port_v2.vip.id
  depends_on = [openstack_networking_router_interface_v2.nodes]
}

resource "openstack_networking_floatingip_v2" "cp" {
  count      = var.cp_count
  pool       = data.openstack_networking_network_v2.external.name
  port_id    = openstack_networking_port_v2.cp[count.index].id
  depends_on = [openstack_networking_router_interface_v2.nodes]
}

resource "openstack_networking_floatingip_v2" "worker" {
  count      = var.worker_count
  pool       = data.openstack_networking_network_v2.external.name
  port_id    = openstack_networking_port_v2.worker[count.index].id
  depends_on = [openstack_networking_router_interface_v2.nodes]
}
