// vars may be defined here but consider not providing defaults here.


// connection specific
variable "proxmox_url" {
    type = string
    description = "Proxmox"
    default = "https://harv.gitbit.cloud:8006/api2/json/"
}

variable "prox_build_node" {
    type = string
    description = "Host responsible for build (harv or sunflower)"
}

variable "prox_username" {
    type = string
    description = "Proxmox connection username"
    // use env var PKR_VAR_prox_username
}

variable "prox_password" {
    type = string
    description = "Proxmox connection password"
    sensitive = true
    default = ""
    // use env var PKR_VAR_prox_password
}

variable "secret_token" {
    type = string
    description = "Proxmox secret token"
    sensitive = true
    // use env var PKR_VAR_secret_token
}

variable "skip_tls_verify" {
    type = bool
    description = "Disable TLS validation to Proxmox instance"
    default = false
}

// node / iso settings
variable "sun_windows_iso_path" {
    type = string
    description = "(Sun) Path to target Windows ISO"
    default = "local:iso/SERVER_EVAL_x64FRE_en-us.iso"

}

variable "sun_windows_iso_sha256" {
    type = string
    description = "(Sun) Windows ISO sha256"
    default = "sha256:3e4fa6d8507b554856fc9ca6079cc402df11a8b79344871669f0251535255325"
}


// template / vm settings
variable "target_template_name" {
    type = string
    description = "Name the template"
}

variable "target_template_description" {
    type = string
    description = "Description"
}

variable "boot_control_type" {
    type = string
    description = "VM boot controller"
}

variable "boot_unmount" {
    type = bool
    description = "Unmount ISO afterwards"
}

// NOTE: this disk area here describes ONE disk
// and you should figure out how to make it like a map
// or whatever in HCL.
// ---note to self---: maps, and lookup(mapname, keyname, default)
variable "vm_disk_type" {
    type = string
    description = "Disk type"
    // can be 'scsi', 'sata', 'virtio', or 'ide'
}

variable "vm_disk_size" {
    type = string
    description = "Size of disk, including suffix"
    // like 10G eg
}

variable "vm_storage_pool" {
    type = string
    description = "Required name of Proxmox storage pool"
}

variable "vm_cache_mode" {
    type = string
    description = "can be 'none', 'writethrough', 'writeback', 'unsafe', 'directsync'."
    default = "none"
}

variable "vm_disk_format" {
    type = string
    description = "can be 'raw', 'cow', 'qcow', 'qed', 'qcow2', 'vmdk', 'cloop'"
    default = "raw"
}

variable "vm_io_thread" {
    type = bool
    description = "requires 'virtio-scsi-single' and 'scsi' or 'virtio' disk"
    default = false
}

variable "vm_disk_discard" {
    type = bool
    description = "Trim to underlying storage"
    // in prox docs this only matters if disk is ssd pretty sure
}

variable "vm_ssd" {
    type = bool
    description = "Enable VM disk SSD"
}
//// end disk
