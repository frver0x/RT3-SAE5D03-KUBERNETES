variable "prefix" {
  type    = string
  default = "k8s"
}

variable "controlplane_count" {
  type    = number
  default = 1
}

variable "worker_count" {
  type    = number
  default = 1
}

variable "image_name" {
  type    = string
  default = "debian-13"
}

variable "image_id" {
  type    = string
  default = "ad08bde3-13e7-4299-9624-0f9718bfce3d"
}

variable "controlplane_flavor" {
  type    = string
  default = "m1.medium"
}

variable "worker_flavor" {
  type    = string
  default = "m1.large"
}


variable "nodes_cidr" {
  type    = string
  default = "172.20.1.0/24"
}

variable "metallb_cidr" {
  type    = string
  default = "172.20.1.196/26"
}

variable "dns_servers" {
  type    = list(string)
  default = ["1.1.1.1"]
}

variable "admin_cidr" {
  type    = string
  default = "10.202.0.0/24"
}

variable "ssh_public_key_path" {
  type    = string
  default = "/home/noak/.ssh/id_ed25519.pub"
}

variable "team_ssh_keys" {
  type = list(string)
  default = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIdz3vZT6BhubnPPB1pFknPREwaz9FflHRZFJAaVN2zW pierre@MacBook-M4.local",
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFTDmkqPgvSsQrBRflhz1mKDCFB3lvISvnS08GWysdIJ ver0x@fedora",
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFTgPz4a4ShNzOuXMFbJlRTZZ/a0MEdY7ALwzwSyniE8 jesuisunintelligent@gmail.com",
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPpdw5ePMtZHnVAJoroVKkn0Xq/geIUxcEkvSqaLqnlf romain.castelli@etu.umontpellier.fr"
  ]
}
variable "ceph_disk_size" {
  type    = number
  default = 10
}

variable "cp_flavor" {
  type    = string
  default = "m1.medium"
}

variable "cp_count" {
  type    = number
  default = 1
}