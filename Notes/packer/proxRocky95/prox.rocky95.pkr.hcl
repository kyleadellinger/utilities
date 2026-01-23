packer {
  required_version = ">= 1.14.0"
  required_plugins {
    qemu = {
      version = ">= 1"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

locals {
  vm_build_description = "Packer built on ${timestamp()}"
}

source "proxmox-iso" "rocky95" {

  node = var.build_node
  proxmox_url = var.proxmox_url
  username = var.prox_username
  insecure_skip_tls_verify = var.skip_tls_verify

  vm_name = var.temp_name
  template_description = local.vm_build_description
  template_name = var.target_template_name

  qemu_agent = 

  boot_iso {
    type =  var.boot_control_type // scsi
    iso_file = 
    iso_checksum = 
    unmount = 
  }

  disks {
    disk_size = var.vm_disk_size
    storage_pool = var.vm_storage_pool
    type = var.vm_disk_type
  }

  network_adapters {
    bridge = var.vm_net_device
    model = var.vm_net_model
  }

  ssh_username   = "root"
  ssh_password   = ""
  ssh_timeout    = "20m"
  vm_name        = "krocky95min"
  net_device     = "virtio-net"
  disk_interface = "virtio"
  boot_wait      = "10s"

}

build {
  sources = ["source.qemu.rocky95"]
  #  provisioner "shell" {
  #    script = "vyos-inner-build.sh"
  #  }
  #provisioner "file" {
  #  source      = "vyos-inner-build.sh"
  #  destination = "/opt/vyatta/config/scripts/vyos-preconfig-bootup.script"

}
