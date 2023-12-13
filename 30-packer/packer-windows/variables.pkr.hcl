variable "winrm_username" {}
variable "winrm_password" {}
variable "vm_name" {}
variable "template_description" {}
variable "iso_file" {}
variable "autounattend_iso" {}
variable "autounattend_checksum" {}
variable "scripts_iso" {}
variable "scripts_checksum" {}
variable "vm_cpu_cores" {}
variable "vm_memory" {}
variable "vm_disk_size" {}
variable "vm_sockets" {}
variable "os" {}
variable "virtio_iso" {}

locals {
  proxmox_node = "${vault("/secrets/packer-windows/proxmox", "proxmox_node")}"
  proxmox_password = "${vault("/secrets/packer-windows/proxmox", "proxmox_password")}"
  proxmox_pool = "${vault("/secrets/packer-windows/proxmox", "proxmox_pool")}"
  proxmox_skip_tls_verify ="${vault("/secrets/packer-windows/proxmox", "proxmox_skip_tls_verify")}"
  proxmox_storage = "${vault("/secrets/packer-windows/proxmox", "proxmox_storage")}"
  proxmox_url = "${vault("/secrets/packer-windows/proxmox", "proxmox_url")}"
  proxmox_username = "${vault("/secrets/packer-windows/proxmox", "proxmox_username")}"
}
