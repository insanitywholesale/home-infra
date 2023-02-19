terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = ">=2.9.5"
    }
  }
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

resource "proxmox_vm_qemu" "proxmox_vm_k3s_ha_masters" {
  provider    = proxmox.pve1
  count       = 1
  name        = "deb-k3s-m-${count.index + 1}"
  desc        = "HA k3s cluster master host ${count.index + 1}"
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
    storage = "local-zfs"
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  ipconfig0 = "ip=10.0.50.${count.index + 51}/24,gw=10.0.50.254"

  sshkeys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC5jzKi37jm3517bqThbw+7LR/GXm3qC6Az5F+ZUa36vYM7Ygk2K5bWcFIL2YUCrkL5jfSsvoowONjCAxyuoyxtW4MJxnQLyq4u4yDsRC7YvBPAKZUYaHwnbkCfDs5a75dEFOoDxCA0DY2GrhqzBndaTcCfl0fZ4vN+9LcKOb1dSKiHeHvsh35YNtwntbL21meo+hiycUEgGwNe9/4kxKpdGTr7HvbeX2Fjm/UZBZIJKVcGop/3gCHXYnKH+OY5zc8cmt9Jg4CIwEqrSKeOX0bE8LSPRpVRXH4v8OcMaMei/HQejlH8NBwybEdJ4mhl8vHaFEjDbIWoOujmiRQF2263 angle@puddle"

  lifecycle {
    ignore_changes = [
      cipassword,
      network,
      desc,
    ]
  }
}

resource "proxmox_vm_qemu" "proxmox_vm_k3s_ha_workers" {
  provider    = proxmox.pve1
  count       = 3
  name        = "deb-k3s-w-${count.index + 1}"
  desc        = "HA k3s cluster worker host ${count.index + 1}"
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
    storage = "local-zfs"
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  ipconfig0 = "ip=10.0.50.${count.index + 61}/24,gw=10.0.50.254"

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
      k3s_masters = proxmox_vm_qemu.proxmox_vm_k3s_ha_masters.*,
      k3s_workers = proxmox_vm_qemu.proxmox_vm_k3s_ha_workers.*,
    }
  )
  filename        = "inventory/k3s-inventory.ini"
  file_permission = "0644"
}
