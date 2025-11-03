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
# variables (cannot be updated during runtime)
# variable "image_name" {
#  type = string
#  default = "ubuntu:jammy"
# }

variable "sun_windows_iso_path" {
  type    = string
  default = "local:iso/SERVER_EVAL_x64FRE_en-us.iso"
}

variable "sun_windows_iso_sha" {
  type    = string
  default = "sha256:3e4fa6d8507b554856fc9ca6079cc402df11a8b79344871669f0251535255325"
}

variable "build_node" {
  type    = string
  default = "harv"
}

variable "proxurl" {
  type    = string
  default = "https://harv.gitbit.cloud:8006/api2/json/"
}

variable "temp_name" {
  type    = string
  default = "packer-92"
}

variable "temp_descrip" {
  type = string
  # default = "Image built ${timestamp}"
  default = "The docs are seemingly wrong about the timestamp funcion"
}

variable "username" {
  type = string
  ## use env var PKR_VAR_username
}

variable "secret_token" {
  type      = string
  sensitive = true
  ## use env var PKR_VAR_secret_token
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

  insecure_skip_tls_verify = false

  boot_iso {
    type         = "scsi"
    iso_file     = var.sun_windows_iso_path
    iso_checksum = var.sun_windows_iso_sha
    # note: additional iso files, virtio drivers, etc.
    unmount = true
  }

  disks {
    disk_size    = "5G"
    #storage_pool = "local-lvm"
    storage_pool = "harv-thin"
    type         = "scsi"
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
