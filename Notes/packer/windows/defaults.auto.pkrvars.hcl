// should be key value pairs only
// which will represent defaults.

prox_build_node = "sunflower"
skip_tls_verify = false

target_template_name = "win86-pkr-template"
target_template_description = "built by packer"

boot_control_type = "scsi"
boot_unmount = true

vm_disk_type = "scsi"
vm_storage_pool = "harv-thin"
vm_cache_mode = "none"
vm_disk_format = "raw"
vm_io_thread = false
vm_disk_discard = true
vm_ssd = true
