resource "local_file" "inventory" {
  filename = "${path.module}/../ansible/inventory/hosts.ini"
  content = templatefile("${path.module}/templates/hosts.ini.tftpl", {
    cps = [for i, s in openstack_compute_instance_v2.cp : {
      name    = s.name
      public  = openstack_networking_floatingip_v2.cp[i].address
      private = openstack_networking_port_v2.cp[i].all_fixed_ips[0]
    }]
    workers = [for i, s in openstack_compute_instance_v2.worker : {
      name    = s.name
      public  = openstack_networking_floatingip_v2.worker[i].address
      private = openstack_networking_port_v2.worker[i].all_fixed_ips[0]
    }]
    vip        = local.vip_ip
    vip_public = openstack_networking_floatingip_v2.vip.address
  })
}
