variable "bridge" {
  type    =  string
  default = "vmbr0"
}

variable "disk_format" {
  type    =  string
  default = "qcow2"
}

variable "disk_size" {
  type    =  string
  default = "16G"
}

variable "iso_storage_pool" {
  type    =  string
  default = "local"
}

variable "node" {
  type    =  string
  default = "srv1"
}

variable "nb_core" {
  type    =  string
  default = "1"
}

variable "nb_cpu" {
  type    =  string
  default = "1"
}

variable "nb_ram" {
  type    =  string
  default = "1024"
}

variable "node_password" {
  type    =  string
  default = "password"
}

variable "node_url" {
  type    =  string
  default = "https://192.168.1.10:8006/api2/json"
}

variable "node_username" {
  type    =  string
  default = "root@pam" # prefer use a specific use for packer on pve realm
}

variable "ssh_username" {
  type    =  string
  default = "user"
}

variable "storage_pool" {
  type    =  string
  default = "datastore"
}

variable "sudo_password" {
  type    =  string
  default = "password"
  sensitive = true
}

variable "type_cpu" {
  type    =  string
  default = "kvm64"
}

variable "vm_id" {
  type    =  number
  default = 99999
}

variable "vm_name" {
  type    =  string
  default = "tmpl-pcker"
}
