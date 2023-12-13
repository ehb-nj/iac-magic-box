packer {
  required_plugins {
    proxmox = {
      version = ">= 1.1.2"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

source "proxmox-iso" "windows" {
  additional_iso_files {
    device           = "sata3"
    iso_checksum     = "${var.autounattend_checksum}"
    iso_storage_pool = "local"
    iso_url          = "${var.autounattend_iso}"
    unmount          = true
  }
  additional_iso_files {
    device   = "sata4"
    iso_file = "${var.virtio_iso}"
    unmount  = true
  }
  additional_iso_files {
    device   = "sata5"
    iso_checksum     = "${var.scripts_checksum}"
    iso_storage_pool = "local"
    iso_url          = "${var.scripts_iso}"
    unmount  = true
  }
  cloud_init              = true
  cloud_init_storage_pool = "${local.proxmox_storage}"
  communicator            = "winrm"
  cores                   = "${var.vm_cpu_cores}"
  disks {
    disk_size         = "${var.vm_disk_size}"
    format            = "raw"
    storage_pool      = "${local.proxmox_storage}"
    type              = "sata"
  }
  insecure_skip_tls_verify = "${local.proxmox_skip_tls_verify}"
  iso_file                 = "${var.iso_file}"
  memory                   = "${var.vm_memory}"
  network_adapters {
    bridge = "vmbr0"
    model  = "virtio"
  }
  node                 = "${local.proxmox_node}"
  os                   = "${var.os}"
  password             = "${local.proxmox_password}"
  pool                 = "${local.proxmox_pool}"
  proxmox_url          = "${local.proxmox_url}"
  sockets              = "${var.vm_sockets}"
  template_description = "${var.template_description}"
  template_name        = "${var.vm_name}"
  username             = "${local.proxmox_username}"
  vm_name              = "${var.vm_name}"
  winrm_insecure       = true
  winrm_no_proxy       = true
  winrm_password       = "${var.winrm_password}"
  winrm_timeout        = "30m"
  winrm_use_ssl        = true
  winrm_username       = "${var.winrm_username}"
}

build {
  sources = ["source.proxmox-iso.windows"]

  provisioner "powershell" {
    elevated_password = "${var.winrm_password}"
    elevated_user     = "${var.winrm_username}"
    scripts           = ["${path.root}/scripts/sysprep/cloudbase-init.ps1"]
    max_retries       = 3
  }

  provisioner "powershell" {
    elevated_password = "${var.winrm_password}"
    elevated_user     = "${var.winrm_username}"
    pause_before      = "1m0s"
    scripts           = ["${path.root}/scripts/sysprep/cloudbase-init-p2.ps1"]
    max_retries       = 3
  }
}
