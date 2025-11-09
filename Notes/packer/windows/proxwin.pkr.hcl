## 'packer' block; define plugins, specify packer version.
packer {
  required_version = ">= 1.14.0"
  required_plugins {
    # each plugin block contains 'version' and 'source'.
    qemu = {
      version = ">= 1" #
      source  = "github.com/hashicorp/proxmox"
      # source only necessary if required plugin is outside HashiCorp domain.
      # if version not specified, packer downloads most recent version.
    }
  }
}

locals {
  vm_build_description = "Packer built on ${timestamp()}"
}

# 'source' block configures a 'builder' plugin, which is to be invoked by the 'build' block, below.
# will use 'builders' and 'communication' to define what virtualization, how to launch, and how to connect.
# 'source' block can be reused across multiple builds, and multiple 'source' can be used in single build.
# two important names: 'builder type' and 'name'.
source "proxmox-iso" "win85" {
  # here, 'proxmox-plugin-name' is 'builder type', and the other part is 'name'.
  ## these things below are attributes
  # image = "ubuntu:jammy"
  ## this is how variables are accessed as attributes:
  # image = var.image_name
  ## this is how variables are accessed string interpolation:
  # image = "echo Running ${var.image_name} Image"

  insecure_skip_tls_verify = var.skip_tls_verify

  // in the docs, this is boot_iso,
  // but in example, it's just 'iso'...
  boot_iso {
    type         = var.boot_control_type
    iso_file     = var.sun_windows_iso_path
    iso_checksum = var.sun_windows_iso_sha
    # note: additional iso files, virtio drivers, etc.
    unmount = var.boot_unmount
  }

  disks {
    disk_size    = var.vm_disk_size
    storage_pool = var.vm_storage_pool
    type         = var.vm_disk_type
  }
  efi_config {
    efi_storage_pool  = "harv-thin"
    efi_type          = "4m"
    pre_enrolled_keys = true
  }
  network_adapters {
    bridge = "vmbr0"
    model  = "virtio"
  }

  vm_name = var.temp_name
  ## which one? or both...
  template_name        = var.temp_name
  template_description = var.temp_descrip

  memory  = 4096
  cores   = 2
  sockets = 1 # default

  #tpm_config {}
  qemu_agent = false # bool


  node        = var.build_node
  proxmox_url = var.proxurl
  username    = var.username
  #password = var.secret_token
  token = var.secret_token
  communicator = "none"
  # winrm
  # ugh.

}

build {
  # the thing that runs everything defined earlier basically
  #
  #name = "learn-packer"
  sources = [
    "source.proxmox-iso.win85"
    ## which is the variable-name-thing noted above, but in dot notation, etc.
    #
  ]
}
