terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = ">=2.9.5"
    }
  }
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

resource "proxmox_vm_qemu" "proxmox_vm_k3s_ha_masters_0" {
  provider    = proxmox.pve0
  count       = 1
  name        = "deb-k3s-m-${(count.index * 2) + 1}"
  desc        = "HA k3s cluster master host"
  target_node = "pve0"

  clone    = "debian-11-template"
  os_type  = "cloud-init"
  cores    = 2
  sockets  = 1
  cpu      = "host"
  memory   = 4096
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

  ipconfig0 = "ip=10.0.50.${(count.index * 2) + 1 + 51}/24,gw=10.0.50.254"

  sshkeys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC5jzKi37jm3517bqThbw+7LR/GXm3qC6Az5F+ZUa36vYM7Ygk2K5bWcFIL2YUCrkL5jfSsvoowONjCAxyuoyxtW4MJxnQLyq4u4yDsRC7YvBPAKZUYaHwnbkCfDs5a75dEFOoDxCA0DY2GrhqzBndaTcCfl0fZ4vN+9LcKOb1dSKiHeHvsh35YNtwntbL21meo+hiycUEgGwNe9/4kxKpdGTr7HvbeX2Fjm/UZBZIJKVcGop/3gCHXYnKH+OY5zc8cmt9Jg4CIwEqrSKeOX0bE8LSPRpVRXH4v8OcMaMei/HQejlH8NBwybEdJ4mhl8vHaFEjDbIWoOujmiRQF2263 angle@puddle"

  lifecycle {
    ignore_changes = [
      cipassword,
      network,
      desc,
    ]
  }
}

resource "proxmox_vm_qemu" "proxmox_vm_k3s_ha_masters_1" {
  provider    = proxmox.pve1
  count       = 1
  name        = "deb-k3s-m-${(count.index * 2) + 2}"
  desc        = "HA k3s cluster master host"
  target_node = "pve1"

  clone    = "debian-11-template"
  os_type  = "cloud-init"
  cores    = 2
  sockets  = 1
  cpu      = "host"
  memory   = 4096
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

  ipconfig0 = "ip=10.0.50.${(count.index * 2) + 2 + 51}/24,gw=10.0.50.254"

  sshkeys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC5jzKi37jm3517bqThbw+7LR/GXm3qC6Az5F+ZUa36vYM7Ygk2K5bWcFIL2YUCrkL5jfSsvoowONjCAxyuoyxtW4MJxnQLyq4u4yDsRC7YvBPAKZUYaHwnbkCfDs5a75dEFOoDxCA0DY2GrhqzBndaTcCfl0fZ4vN+9LcKOb1dSKiHeHvsh35YNtwntbL21meo+hiycUEgGwNe9/4kxKpdGTr7HvbeX2Fjm/UZBZIJKVcGop/3gCHXYnKH+OY5zc8cmt9Jg4CIwEqrSKeOX0bE8LSPRpVRXH4v8OcMaMei/HQejlH8NBwybEdJ4mhl8vHaFEjDbIWoOujmiRQF2263 angle@puddle"

  lifecycle {
    ignore_changes = [
      cipassword,
      network,
      desc,
    ]
  }
}
resource "proxmox_vm_qemu" "proxmox_vm_k3s_ha_masters_2" {
  provider    = proxmox.pve2
  count       = 1
  name        = "deb-k3s-m-${(count.index * 2) + 3}"
  desc        = "HA k3s cluster master host"
  target_node = "pve2"

  clone    = "debian-11-template"
  os_type  = "cloud-init"
  cores    = 2
  sockets  = 1
  cpu      = "host"
  memory   = 4096
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

  ipconfig0 = "ip=10.0.50.${(count.index * 2) + 3 + 51}/24,gw=10.0.50.254"

  sshkeys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC5jzKi37jm3517bqThbw+7LR/GXm3qC6Az5F+ZUa36vYM7Ygk2K5bWcFIL2YUCrkL5jfSsvoowONjCAxyuoyxtW4MJxnQLyq4u4yDsRC7YvBPAKZUYaHwnbkCfDs5a75dEFOoDxCA0DY2GrhqzBndaTcCfl0fZ4vN+9LcKOb1dSKiHeHvsh35YNtwntbL21meo+hiycUEgGwNe9/4kxKpdGTr7HvbeX2Fjm/UZBZIJKVcGop/3gCHXYnKH+OY5zc8cmt9Jg4CIwEqrSKeOX0bE8LSPRpVRXH4v8OcMaMei/HQejlH8NBwybEdJ4mhl8vHaFEjDbIWoOujmiRQF2263 angle@puddle"

  lifecycle {
    ignore_changes = [
      cipassword,
      network,
      desc,
    ]
  }
}

resource "proxmox_vm_qemu" "proxmox_vm_k3s_ha_workers_0" {
  provider    = proxmox.pve0
  count       = 1
  name        = "deb-k3s-w-${(count.index * 2) + 1}"
  desc        = "HA k3s cluster worker host"
  target_node = "pve0"

  clone    = "debian-11-template"
  os_type  = "cloud-init"
  cores    = 2
  sockets  = 1
  cpu      = "host"
  memory   = 4096
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

  ipconfig0 = "ip=10.0.50.${(count.index * 2) + 1 + 61}/24,gw=10.0.50.254"

  sshkeys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC5jzKi37jm3517bqThbw+7LR/GXm3qC6Az5F+ZUa36vYM7Ygk2K5bWcFIL2YUCrkL5jfSsvoowONjCAxyuoyxtW4MJxnQLyq4u4yDsRC7YvBPAKZUYaHwnbkCfDs5a75dEFOoDxCA0DY2GrhqzBndaTcCfl0fZ4vN+9LcKOb1dSKiHeHvsh35YNtwntbL21meo+hiycUEgGwNe9/4kxKpdGTr7HvbeX2Fjm/UZBZIJKVcGop/3gCHXYnKH+OY5zc8cmt9Jg4CIwEqrSKeOX0bE8LSPRpVRXH4v8OcMaMei/HQejlH8NBwybEdJ4mhl8vHaFEjDbIWoOujmiRQF2263 angle@puddle"

  lifecycle {
    ignore_changes = [
      cipassword,
      network,
      desc,
    ]
  }
}

resource "proxmox_vm_qemu" "proxmox_vm_k3s_ha_workers_1" {
  provider    = proxmox.pve1
  count       = 1
  name        = "deb-k3s-w-${(count.index * 2) + 2}"
  desc        = "HA k3s cluster worker host"
  target_node = "pve1"

  clone    = "debian-11-template"
  os_type  = "cloud-init"
  cores    = 2
  sockets  = 1
  cpu      = "host"
  memory   = 4096
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

  ipconfig0 = "ip=10.0.50.${(count.index * 2) + 2 + 61}/24,gw=10.0.50.254"

  sshkeys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC5jzKi37jm3517bqThbw+7LR/GXm3qC6Az5F+ZUa36vYM7Ygk2K5bWcFIL2YUCrkL5jfSsvoowONjCAxyuoyxtW4MJxnQLyq4u4yDsRC7YvBPAKZUYaHwnbkCfDs5a75dEFOoDxCA0DY2GrhqzBndaTcCfl0fZ4vN+9LcKOb1dSKiHeHvsh35YNtwntbL21meo+hiycUEgGwNe9/4kxKpdGTr7HvbeX2Fjm/UZBZIJKVcGop/3gCHXYnKH+OY5zc8cmt9Jg4CIwEqrSKeOX0bE8LSPRpVRXH4v8OcMaMei/HQejlH8NBwybEdJ4mhl8vHaFEjDbIWoOujmiRQF2263 angle@puddle"

  lifecycle {
    ignore_changes = [
      cipassword,
      network,
      desc,
    ]
  }
}

resource "proxmox_vm_qemu" "proxmox_vm_k3s_ha_workers_2" {
  provider    = proxmox.pve2
  count       = 1
  name        = "deb-k3s-w-${(count.index * 2) + 3}"
  desc        = "HA k3s cluster worker host"
  target_node = "pve2"

  clone    = "debian-11-template"
  os_type  = "cloud-init"
  cores    = 2
  sockets  = 1
  cpu      = "host"
  memory   = 4096
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

  ipconfig0 = "ip=10.0.50.${(count.index * 2 ) + 3 + 61}/24,gw=10.0.50.254"

  sshkeys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC5jzKi37jm3517bqThbw+7LR/GXm3qC6Az5F+ZUa36vYM7Ygk2K5bWcFIL2YUCrkL5jfSsvoowONjCAxyuoyxtW4MJxnQLyq4u4yDsRC7YvBPAKZUYaHwnbkCfDs5a75dEFOoDxCA0DY2GrhqzBndaTcCfl0fZ4vN+9LcKOb1dSKiHeHvsh35YNtwntbL21meo+hiycUEgGwNe9/4kxKpdGTr7HvbeX2Fjm/UZBZIJKVcGop/3gCHXYnKH+OY5zc8cmt9Jg4CIwEqrSKeOX0bE8LSPRpVRXH4v8OcMaMei/HQejlH8NBwybEdJ4mhl8vHaFEjDbIWoOujmiRQF2263 angle@puddle"

  lifecycle {
    ignore_changes = [
      cipassword,
      network,
      desc,
    ]
  }
}

/* this is also interesting https://github.com/NatiSayada/k3s-proxmox-terraform-ansible/blob/main/terraform/main.tf */
resource "local_file" "hosts_cfg_k3s" {
  content = templatefile(
    "${path.module}/inventory/k3s-inventory.ini.tftpl",
    {
      k3s_masters = concat(proxmox_vm_qemu.proxmox_vm_k3s_ha_masters_0.*,proxmox_vm_qemu.proxmox_vm_k3s_ha_masters_1.*,proxmox_vm_qemu.proxmox_vm_k3s_ha_masters_2.*),
      k3s_workers = concat(proxmox_vm_qemu.proxmox_vm_k3s_ha_workers_0.*,proxmox_vm_qemu.proxmox_vm_k3s_ha_workers_1.*,proxmox_vm_qemu.proxmox_vm_k3s_ha_workers_2.*),
    }
  )
  filename        = "inventory/k3s-inventory.ini"
  file_permission = "0644"
}
