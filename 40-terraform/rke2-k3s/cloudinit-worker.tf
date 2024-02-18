# create master
resource "proxmox_virtual_environment_vm" "vm_worker" {
  count = var.vmdata.worker_count
  name  = "${var.vmdata.worker_vm_basename}-${format("%02.0f",count.index+1)}"
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
    size = var.vmdata.worker_disk_size
    file_format = "raw"
  }

  cpu {
    cores = var.vmdata.worker_cores
    sockets = var.vmdata.worker_socket
  }

  memory {
    dedicated = var.vmdata.worker_mem
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
        address = "${var.vmdata.ip_first_three_block}.${var.vmdata.ip_last_block_start + var.vmdata.master_count + count.index}/24"
        gateway = "${var.vmdata.ip_gw}"
      } 
    }
    dns {
      domain  = "${var.vmdata.rke_domain}"
      servers = ["${var.vmdata.ip_dns}"]
    }
    user_data_file_id = "${proxmox_virtual_environment_file.worker_user_data[count.index].id}"
  }

  pool_id = "${var.vmdata.pve_pool}"

  depends_on = [ proxmox_virtual_environment_file.worker_user_data, proxmox_virtual_environment_vm.vm_master[0] ]
}

# template file for worker
data "template_file" "worker_user_data" {
  count = var.vmdata.worker_count
  template = file("${path.module}/templates/cloud_init_worker.cfg")
  vars = {
    KUBERNETES_DISTRIB = var.vmdata.kubernetes,
    HOSTNAME = "${var.vmdata.worker_vm_basename}-${format("%02.0f",count.index+1)}",
    USERNAME = var.vmdata.username,
    KUBERNETES_WORKER_COUNT = var.vmdata.worker_count,
    KUBERNETES_JOIN_TOKEN = random_password.kube_token.result,
    KUBERNETES_MASTER_JOIN_IP =  "${var.vmdata.ip_first_three_block}.${var.vmdata.ip_last_block_start}",
    SSH_KEY=local.ssh_data.public_key
  }
  depends_on = [ proxmox_virtual_environment_pool.operations_pool ]
}

resource "proxmox_virtual_environment_file" "worker_user_data" {
  count = var.vmdata.worker_count
  content_type = "snippets"
  datastore_id = "local"
  node_name = var.vmdata.pve_node

  source_raw {
    data = data.template_file.worker_user_data[count.index].rendered
    file_name = "cloud_init_${var.vmdata.kubernetes}-worker-${format("%02.0f",count.index+1)}.yml"
  }
  depends_on = [ data.template_file.worker_user_data ]
}