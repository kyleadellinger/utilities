// should be key value pairs only
// which will represent defaults.

prox_build_node = "sunflower"
skip_tls_verify = false

target_template_name = "rocky95-pkr-template"

boot_control_type = "scsi"
boot_unmount = true

vm_disk_size = "10G"
vm_disk_type = "scsi"
vm_storage_pool = "harv-thin"
vm_cache_mode = "none"
vm_disk_format = "qcow2"
vm_io_thread = false
vm_disk_discard = true
vm_ssd = true

vm_net_device = "vmbr0"
vm_net_model = "virtio"

#iso_url = "local:iso/rocky-boot.iso"
iso_url = "/var/lib/vz/template/iso/rocky-boot.iso"
iso_checksum = "sha256:11e42da96a7b336de04e60d05e54a22999c4d7f3e92c19ebf31f9c71298f5b42"

#iso_url = "file::./Rocky95-min.iso"
#iso_checksum = "eedbdc2875c32c7f00e70fc861edef48587c7cbfd106885af80bdf434543820b"
