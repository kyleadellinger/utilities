source "proxmox-iso" "vyostest" {

  vm_name         = "vyospacker"
  vm_id           = "420"
  cpu_type        = "host"
  scsi_controller = "virtio-scsi-single"

  sockets = 1
  cores   = 1
  memory  = 2048

  boot_iso {
    type         = "scsi"
    iso_file     = "local:iso/ky-sagitta-amd64.hybrid.iso"
    iso_checksum = "sha256:SUM"
    unmount      = true
  }

  network_adapters {
    bridge = "vmbr0"
    model  = "virtio"
    # mac_address = str # nice
    # vlan_tag = str # defaults no tagging
    # firewall = bool # defaults false

    # would need to specify all of them
  }

  network_adapters {
    bridge = "vmbr2"
    model  = "virtio"
    # mac_address
  }

  disks {
    type         = "scsi"
    storage_pool = "local-lvm"
    disk_size    = "6G"
    format = "raw"
  }

  node        = "$NODE.USER"
  password    = "$NODE.PW"
  proxmox_url = "https://node:8006/api2/json"
  # ssh_password = "packer"
  # ssh_timeout  = "15m"
  # ssh_username = "root"
  username     = "packer@pam"
  communicator = "none"
}

build {
  sources = ["source.proxmox-iso.vyostest"]
  
  # reference:
  #  provisioner "shell" {
  #    script = "vyos-inner-build.sh"
  #  }
  # provisioner "file" {
  #  source      = "vyos-inner-build.sh"
  #  destination = "/opt/vyatta/config/scripts/vyos-preconfig-bootup.script"
  }

}
