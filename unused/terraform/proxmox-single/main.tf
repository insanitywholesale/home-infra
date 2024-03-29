terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = ">=2.9.14"
    }
  }
  backend "http" {}
}

provider "proxmox" {
  alias           = "pve0"
  pm_tls_insecure = true
  pm_api_url      = "https://10.0.50.70:8006/api2/json"
  pm_password     = "failfail"
  pm_user         = "root@pam"
  pm_timeout      = 900
}

provider "proxmox" {
  alias           = "pve1"
  pm_tls_insecure = true
  pm_api_url      = "https://10.0.50.71:8006/api2/json"
  pm_password     = "failfail"
  pm_user         = "root@pam"
  pm_timeout      = 900
}

provider "proxmox" {
  alias           = "pve2"
  pm_tls_insecure = true
  pm_api_url      = "https://10.0.50.72:8006/api2/json"
  pm_password     = "failfail"
  pm_user         = "root@pam"
  pm_timeout      = 900
}

resource "proxmox_vm_qemu" "proxmox_vm_pihole" {
  provider    = proxmox.pve0
  vmid        = 102
  count       = 1
  name        = "pihole-${count.index}"
  desc        = "pihole! in a VM!! number ${(count.index) + 1} of its kind"
  target_node = "pve0"

  clone    = "debian-11-template"
  os_type  = "cloud-init"
  qemu_os  = "l26"
  vcpus    = 0
  cores    = 1
  sockets  = 1
  cpu      = "host"
  memory   = 1536
  scsihw   = "virtio-scsi-pci"
  bootdisk = "virtio0"
  agent    = 1
  onboot   = true

  disk {
    size    = "30G"
    type    = "virtio"
    storage = "local-lvm"
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  ipconfig0 = "ip=10.0.50.${(count.index) + 2}/24,gw=10.0.50.254"

  sshkeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIgah15+jjufEiziZxhrmus/EVq9gPRqHMX5Ejl5dtWk angle"

  lifecycle {
    ignore_changes = [
      cipassword,
      network,
      desc,
    ]
  }
}

resource "proxmox_vm_qemu" "proxmox_vm_postgres" {
  provider    = proxmox.pve0
  vmid        = 120
  count       = 1
  name        = "postgres-${count.index}"
  desc        = "postgres instance index ${count.index}"
  target_node = "pve0"

  clone    = "debian-11-template"
  os_type  = "cloud-init"
  qemu_os  = "l26"
  vcpus    = 0
  cores    = 2
  sockets  = 1
  cpu      = "host"
  memory   = 2560
  scsihw   = "virtio-scsi-pci"
  bootdisk = "virtio0"
  agent    = 1
  onboot   = true

  disk {
    size    = "90G"
    type    = "virtio"
    storage = "local-lvm"
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  ipconfig0 = "ip=10.0.50.${(count.index) + 20}/24,gw=10.0.50.254"

  sshkeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIgah15+jjufEiziZxhrmus/EVq9gPRqHMX5Ejl5dtWk angle"

  lifecycle {
    ignore_changes = [
      cipassword,
      network,
      desc,
    ]
  }
}

resource "proxmox_vm_qemu" "proxmox_vm_mysql" {
  provider    = proxmox.pve0
  vmid        = 121
  count       = 1
  name        = "mysql-${count.index}"
  desc        = "mysql instance index ${count.index}"
  target_node = "pve0"

  clone    = "debian-11-template"
  os_type  = "cloud-init"
  qemu_os  = "l26"
  vcpus    = 0
  cores    = 2
  sockets  = 1
  cpu      = "host"
  memory   = 2048
  scsihw   = "virtio-scsi-pci"
  bootdisk = "virtio0"
  agent    = 1
  onboot   = true

  disk {
    size    = "60G"
    type    = "virtio"
    storage = "local-lvm"
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  ipconfig0 = "ip=10.0.50.${(count.index) + 21}/24,gw=10.0.50.254"

  sshkeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIgah15+jjufEiziZxhrmus/EVq9gPRqHMX5Ejl5dtWk angle"

  lifecycle {
    ignore_changes = [
      cipassword,
      network,
      desc,
    ]
  }
}

resource "proxmox_vm_qemu" "proxmox_vm_observium" {
  provider    = proxmox.pve1
  vmid        = 132
  count       = 1
  name        = "observium-${count.index}"
  desc        = "observium instance index ${count.index}"
  target_node = "pve1"

  clone    = "debian-11-template"
  os_type  = "cloud-init"
  qemu_os  = "l26"
  vcpus    = 0
  cores    = 2
  sockets  = 1
  cpu      = "host"
  memory   = 4096
  scsihw   = "virtio-scsi-pci"
  bootdisk = "virtio0"
  agent    = 1
  onboot   = true

  disk {
    size    = "55G"
    type    = "virtio"
    storage = "local-lvm"
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  ipconfig0 = "ip=10.0.50.${(count.index) + 32}/24,gw=10.0.50.254"

  sshkeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIgah15+jjufEiziZxhrmus/EVq9gPRqHMX5Ejl5dtWk angle"

  lifecycle {
    ignore_changes = [
      cipassword,
      network,
      desc,
    ]
  }
}

resource "proxmox_vm_qemu" "proxmox_vm_gitlab" {
  provider    = proxmox.pve2
  vmid        = 145
  count       = 1
  name        = "gitlab-${count.index}"
  desc        = "gitlab instance index ${count.index}"
  target_node = "pve2"

  clone    = "debian-11-template"
  os_type  = "cloud-init"
  qemu_os  = "l26"
  vcpus    = 0
  cores    = 4
  sockets  = 1
  cpu      = "host"
  memory   = 6144
  scsihw   = "virtio-scsi-pci"
  bootdisk = "virtio0"
  agent    = 1
  onboot   = true

  disk {
    size    = "80G"
    type    = "virtio"
    storage = "local-lvm"
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  ipconfig0 = "ip=10.0.50.${(count.index) + 45}/24,gw=10.0.50.254"

  sshkeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIgah15+jjufEiziZxhrmus/EVq9gPRqHMX5Ejl5dtWk angle"

  lifecycle {
    ignore_changes = [
      cipassword,
      network,
      desc,
    ]
  }
}

resource "proxmox_vm_qemu" "proxmox_vm_k3s_ha_master" {
  provider    = proxmox.pve0
  vmid        = (count.index) + 151
  count       = 1
  name        = "k3s-m-${count.index}"
  desc        = "k3s cluster control plane node number ${(count.index) + 1}"
  target_node = "pve0"

  clone    = "debian-11-template"
  os_type  = "cloud-init"
  qemu_os  = "l26"
  vcpus    = 0
  cores    = 2
  sockets  = 1
  cpu      = "host"
  memory   = 4096
  scsihw   = "virtio-scsi-pci"
  bootdisk = "virtio0"
  agent    = 1
  onboot   = true

  disk {
    size    = "40G"
    type    = "virtio"
    storage = "local-lvm"
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  ipconfig0 = "ip=10.0.50.${(count.index) + 51}/24,gw=10.0.50.254"

  sshkeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIgah15+jjufEiziZxhrmus/EVq9gPRqHMX5Ejl5dtWk angle"

  lifecycle {
    ignore_changes = [
      cipassword,
      network,
      desc,
    ]
  }
}

resource "proxmox_vm_qemu" "proxmox_vm_k3s_ha_workers" {
  provider    = proxmox.pve0
  vmid        = (count.index) + 161
  count       = 3
  name        = "k3s-w-${count.index}"
  desc        = "k3s cluster worker node number ${(count.index) + 1}"
  target_node = "pve0"

  clone    = "debian-11-template"
  os_type  = "cloud-init"
  qemu_os  = "l26"
  vcpus    = 0
  cores    = 2
  sockets  = 1
  cpu      = "host"
  memory   = 2560
  scsihw   = "virtio-scsi-pci"
  bootdisk = "virtio0"
  agent    = 1
  onboot   = true

  disk {
    size    = "50G"
    type    = "virtio"
    storage = "local-lvm"
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  ipconfig0 = "ip=10.0.50.${(count.index) + 61}/24,gw=10.0.50.254"

  sshkeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIgah15+jjufEiziZxhrmus/EVq9gPRqHMX5Ejl5dtWk angle"

  lifecycle {
    ignore_changes = [
      cipassword,
      network,
      desc,
    ]
  }
}

resource "proxmox_vm_qemu" "proxmox_vm_k3s_single" {
  provider    = proxmox.pve1
  vmid        = (count.index) + 169
  count       = 1
  name        = "k3s-single"
  desc        = "k3s single-node cluster"
  target_node = "pve1"

  clone    = "debian-11-template"
  os_type  = "cloud-init"
  qemu_os  = "l26"
  vcpus    = 0
  cores    = 4
  sockets  = 1
  cpu      = "host"
  memory   = 8192
  scsihw   = "virtio-scsi-pci"
  bootdisk = "virtio0"
  agent    = 1
  onboot   = true

  disk {
    size    = "50G"
    type    = "virtio"
    storage = "local-lvm"
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  ipconfig0 = "ip=10.0.50.69/24,gw=10.0.50.254"

  sshkeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIgah15+jjufEiziZxhrmus/EVq9gPRqHMX5Ejl5dtWk angle"

  lifecycle {
    ignore_changes = [
      cipassword,
      network,
      desc,
    ]
  }
}

resource "local_file" "hosts_cfg_k3s" {
  content = templatefile(
    "${path.module}/inventory/k3s-inventory.ini.tftpl",
    {
      k3s_masters = concat(proxmox_vm_qemu.proxmox_vm_k3s_ha_master.*),
      k3s_workers = concat(proxmox_vm_qemu.proxmox_vm_k3s_ha_workers.*),
    }
  )
  filename        = "inventory/k3s-inventory.ini"
  file_permission = "0644"
}
