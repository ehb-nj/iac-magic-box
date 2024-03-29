# create master
resource "proxmox_virtual_environment_vm" "vm_master" {
  count = var.vmdata.master_count
  name  = "${var.vmdata.master_vm_basename}-${format("%02.0f",count.index+1)}"
  description = "Managed by Terraform / ${var.vmdata.kubernetes}"
  tags        = ["terraform", "ubuntu", "${var.vmdata.kubernetes}"]

  node_name = var.vmdata.pve_node

  agent {
    # read 'Qemu guest agent' section, change to true only when ready
    enabled = true
  }

  clone {
    vm_id = var.vmdata.os_template
  }

  disk {
    datastore_id = var.vmdata.diskstorage
    interface    = "scsi0"
    size = var.vmdata.master_disk_size
    file_format = "raw"
  }

  cpu {
    cores = var.vmdata.master_cores
    sockets = var.vmdata.master_socket
  }

  memory {
    dedicated = var.vmdata.master_mem
  }

  network_device {
    bridge = var.vmdata.network_bridge
    model = "virtio"
    firewall = false
    mtu = var.vmdata.mtu
  }

  initialization {
    datastore_id = var.vmdata.diskstorage
    ip_config {
      ipv4 {
        address = "${var.vmdata.ip_first_three_block}.${var.vmdata.ip_last_block_start + count.index}/24"
        gateway = "${var.vmdata.ip_gw}"
      }
    }
    dns {
      domain  = "${var.vmdata.rke_domain}"
      servers = ["${var.vmdata.ip_dns}"]
    }
    user_data_file_id = "${proxmox_virtual_environment_file.master_user_data[count.index].id}"
  }

  depends_on = [ proxmox_virtual_environment_file.master_user_data, proxmox_virtual_environment_vm.vm_master[0] ]

  pool_id = "${var.vmdata.pve_pool}"
}

# cloudinit file for master
data "template_file" "master_user_data" {
  count = var.vmdata.master_count
  template = file("${path.module}/templates/cloud_init_master.cfg")
  vars = {
    HOSTNAME = "${var.vmdata.master_vm_basename}-${format("%02.0f",count.index+1)}",
    USERNAME = var.vmdata.username,
    KUBERNETES_DISTRIB = var.vmdata.kubernetes,
    KUBERNETES_MASTER_ACTUAL = count.index,
    KUBERNETES_MASTER_COUNT = var.vmdata.master_count,
    KUBERNETES_MASTER_JOIN_IP = "${var.vmdata.ip_first_three_block}.${var.vmdata.ip_last_block_start}",
    KUBERNETES_JOIN_TOKEN = random_password.kube_token.result,
    SSH_KEY=local.ssh_data.public_key
  }
  depends_on = [ proxmox_virtual_environment_pool.operations_pool ]
}

resource "proxmox_virtual_environment_file" "master_user_data" {
  count = var.vmdata.master_count
  content_type = "snippets"
  datastore_id = "local"
  node_name = var.vmdata.pve_node

  source_raw {
    data = data.template_file.master_user_data[count.index].rendered
    file_name = "cloud_init_${var.vmdata.kubernetes}-master-${format("%02.0f",count.index+1)}.yml"
  }
  depends_on = [ data.template_file.master_user_data ,random_password.kube_token ]
}

resource "proxmox_virtual_environment_pool" "operations_pool" {
  comment = "Managed by Terraform"
  pool_id = "${var.vmdata.pve_pool}"
}