variable "autounattend_checksum" {}
variable "autounattend_iso" {}
variable "iso_file" {}
variable "os" {}
variable "scripts_checksum" {}
variable "scripts_iso" {}
variable "template_description" {}
variable "virtio_iso" {}
variable "vm_cpu_cores" {}
variable "vm_disk_size" {}
variable "vm_memory" {}
variable "vm_name" {}
variable "vm_sockets" {}
variable "winrm_password" {}
variable "winrm_username" {}
variable "tags" {}

locals {
  proxmox_node            = "${vault("/secrets/packer-windows/proxmox", "proxmox_node")}"
  proxmox_password        = "${vault("/secrets/packer-windows/proxmox", "proxmox_password")}"
  proxmox_pool            = "${vault("/secrets/packer-windows/proxmox", "proxmox_pool")}"
  proxmox_skip_tls_verify = "${vault("/secrets/packer-windows/proxmox", "proxmox_skip_tls_verify")}"
  proxmox_storage         = "${vault("/secrets/packer-windows/proxmox", "proxmox_storage")}"
  proxmox_url             = "${vault("/secrets/packer-windows/proxmox", "proxmox_url")}"
  proxmox_username        = "${vault("/secrets/packer-windows/proxmox", "proxmox_username")}"
  proxmox_bridge          = "${vault("/secrets/packer-windows/proxmox", "proxmox_bridge")}"
}
