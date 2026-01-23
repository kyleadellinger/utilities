packer {
  required_version = ">= 1.14.0"
  required_plugins {
    qemu = {
      version = "~> 1"
      source  = "github.com/hashicorp/qemu"
    }
  }
}
source "qemu" "rocky95" {
  iso_url          = "file::./Rocky95-min.iso"
  iso_checksum     = "eedbdc2875c32c7f00e70fc861edef48587c7cbfd106885af80bdf434543820b"
  output_directory = "_rocky95_min_kvm"
  disk_size        = "5000M"
  format           = "qcow2"
  accelerator      = "kvm"

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
