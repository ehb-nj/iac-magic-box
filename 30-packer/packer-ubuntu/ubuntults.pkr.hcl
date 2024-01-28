packer {
  required_plugins {
    name = {
      version = ">1.1.6"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

variable "boot" {
  type = string
}
variable "bios_type" {
  type = string
}
variable "boot_command" {
  type = string
}
variable "boot_wait" {
  type = string
}
variable "bridge_firewall" {
  type    = bool
  default = false
}
variable "bridge_name" {
  type = string
}
variable "cloud_init" {
  type = bool
}
variable "io_thread" {
  type = bool
}
variable "iso_file" {
  type = string
}
variable "iso_storage_pool" {
  type    = string
  default = "local"
}
variable "machine_default_type" {
  type    = string
  default = "pc"
}
variable "network_model" {
  type    = string
  default = "virtio"
}
variable "os_type" {
  type    = string
  default = "l26"
}
variable "proxmox_username" {
  type = string
}
variable "proxmox_password" {
  type      = string
  sensitive = true
}
variable "proxmox_api_url" {
  type = string
}
variable "proxmox_node" {
  type = string
}
variable "qemu_agent_activation" {
  type    = bool
  default = true
}
variable "scsi_controller_type" {
  type = string
}
variable "ssh_timeout" {
  type = string
}
variable "tags" {
  type = string
}
variable "cpu_type" {
  type    = string
  default = "kvm64"
}
variable "vm_info" {
  type = string
}
variable "disk_discard" {
  type    = bool
  default = true
}
variable "disk_format" {
  type    = string
  default = "qcow2"
}
variable "disk_size" {
  type    = string
  default = "16G"
}
variable "disk_type" {
  type    = string
  default = "scsi"
}
variable "nb_core" {
  type    = number
  default = 1
}
variable "nb_cpu" {
  type    = number
  default = 1
}
variable "nb_ram" {
  type    = number
  default = 1024
}
variable "ssh_username" {
  type = string
}
variable "ssh_handshake_attempts" {
  type = number
}
variable "storage_pool" {
  type = string
}
variable "vm_id" {
  type    = number
  default = 99999
}
variable "vm_name" {
  type = string
}

locals {
  packer_timestamp = formatdate("YYYYMMDD-hhmm", timestamp())
}

source "proxmox-iso" "ubuntujammy" {
  bios                     = "${var.bios_type}"
  boot                     = "${var.boot}"
  boot_command             = ["${var.boot_command}"]
  boot_wait                = "${var.boot_wait}"
  cloud_init               = "${var.cloud_init}"
  cloud_init_storage_pool  = "${var.storage_pool}"
  communicator             = "ssh"
  cores                    = "${var.nb_core}"
  cpu_type                 = "${var.cpu_type}"
  http_directory           = "autoinstall"
  insecure_skip_tls_verify = true
  iso_file                 = "${var.iso_file}"
  machine                  = "${var.machine_default_type}"
  memory                   = "${var.nb_ram}"
  node                     = "${var.proxmox_node}"
  os                       = "${var.os_type}"
  password                 = "${var.proxmox_password}"
  proxmox_url              = "${var.proxmox_api_url}"
  qemu_agent               = "${var.qemu_agent_activation}"
  scsi_controller          = "${var.scsi_controller_type}"
  sockets                  = "${var.nb_cpu}"
  ssh_handshake_attempts   = "${var.ssh_handshake_attempts}"
  ssh_pty                  = true
  ssh_timeout              = "${var.ssh_timeout}"
  ssh_username             = "${var.ssh_username}"
  tags                     = "${var.tags}"
  template_description     = "${var.vm_info} - ${local.packer_timestamp}"
  unmount_iso              = true
  username                 = "${var.proxmox_username}"
  vm_id                    = "${var.vm_id}"
  vm_name                  = "${var.vm_name}"

  disks {
    discard      = "${var.disk_discard}"
    disk_size    = "${var.disk_size}"
    format       = "${var.disk_format}"
    io_thread    = "${var.io_thread}"
    storage_pool = "${var.storage_pool}"
    type         = "${var.disk_type}"
  }

  network_adapters {
    bridge   = "${var.bridge_name}"
    firewall = "${var.bridge_firewall}"
    model    = "${var.network_model}"
  }

  vga {
    type = "virtio"
  }
}

build {
  sources = ["source.proxmox-iso.ubuntujammy"]

  # Waiting for Cloud-Init to finish
  provisioner "shell" {
    inline = ["cloud-init status --wait"]
  }

  # Provisioning the VM Template for Cloud-Init Integration in Proxmox
  provisioner "shell" {
    execute_command = "echo -e '<user>' | sudo -S -E bash '{{ .Path }}'"
    inline = [
      "echo 'Starting Stage: Provisioning the VM Template for Cloud-Init Integration in Proxmox'",
      "sudo rm /etc/ssh/ssh_host_*",
      "sudo truncate -s 0 /etc/machine-id",
      "sudo apt -y autoremove --purge",
      "sudo apt -y clean",
      "sudo apt -y autoclean",
      "sudo cloud-init clean",
      "sudo rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg",
      "sudo rm -f /etc/netplan/00-installer-config.yaml",
      "sudo sync",
      "echo 'Done Stage: Provisioning the VM Template for Cloud-Init Integration in Proxmox'"
    ]
  }
}
