resource "proxmox_vm_qemu" "proxmox_vm_k3s_ha_workers_0_cluster_2" {
  count       = 0
  vmid        = 1000 + (count.index * 3) + 67
  name        = format("k3s-w%02s-c%02s", (count.index * 3) + 1, 2)
  desc        = format("HA k3s agent/worker %02s for cluster %02s", (count.index * 3) + 1, 2)
  target_node = "pve01"

  clone    = "deb11-tmpl"
  os_type  = "cloud-init"
  qemu_os  = "l26"
  cpu      = "SandyBridge"
  cores    = 2
  sockets  = 1
  memory   = 3072
  scsihw   = "virtio-scsi-pci"
  bootdisk = "virtio0"
  agent    = 1
  onboot   = true

  disks {
    virtio {
      virtio0 {
        disk {
          size    = 30
          storage = "local-lvm"
        }
      }
    }
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  ipconfig0 = "ip=10.0.50.${(count.index * 3) + 67}/24,gw=10.0.50.254"

  sshkeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIgah15+jjufEiziZxhrmus/EVq9gPRqHMX5Ejl5dtWk angle"

  tags = format("agent;cluster%02s;debian;k3s;worker", 2)

  lifecycle {
    ignore_changes = [
      cipassword,
      network,
    ]
  }
}

resource "proxmox_vm_qemu" "proxmox_vm_k3s_ha_workers_1_cluster_2" {
  count       = 0
  vmid        = 1000 + (count.index * 3) + 68
  name        = format("k3s-w%02s-c%02s", (count.index * 3) + 2, 2)
  desc        = format("HA k3s agent/worker %02s for cluster %02s", (count.index * 3) + 2, 2)
  target_node = "pve02"

  clone    = "deb11-tmpl"
  os_type  = "cloud-init"
  qemu_os  = "l26"
  cpu      = "SandyBridge"
  cores    = 2
  sockets  = 1
  memory   = 3072
  scsihw   = "virtio-scsi-pci"
  bootdisk = "virtio0"
  agent    = 1
  onboot   = true

  disks {
    virtio {
      virtio0 {
        disk {
          size    = 30
          storage = "local-lvm"
        }
      }
    }
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  ipconfig0 = "ip=10.0.50.${(count.index * 3) + 68}/24,gw=10.0.50.254"

  sshkeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIgah15+jjufEiziZxhrmus/EVq9gPRqHMX5Ejl5dtWk angle"

  tags = format("agent;cluster%02s;debian;k3s;worker", 2)

  lifecycle {
    ignore_changes = [
      cipassword,
      network,
    ]
  }
}

resource "proxmox_vm_qemu" "proxmox_vm_k3s_ha_workers_2_cluster_2" {
  count       = 0
  vmid        = 1000 + (count.index * 3) + 69
  name        = format("k3s-w%02s-c%02s", (count.index * 3) + 3, 2)
  desc        = format("HA k3s agent/worker %02s for cluster %02s", (count.index * 3) + 3, 2)
  target_node = "pve03"

  clone    = "deb11-tmpl"
  os_type  = "cloud-init"
  qemu_os  = "l26"
  cpu      = "SandyBridge"
  cores    = 2
  sockets  = 1
  memory   = 3072
  scsihw   = "virtio-scsi-pci"
  bootdisk = "virtio0"
  agent    = 1
  onboot   = true

  disks {
    virtio {
      virtio0 {
        disk {
          size    = 30
          storage = "local-lvm"
        }
      }
    }
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  ipconfig0 = "ip=10.0.50.${(count.index * 3) + 69}/24,gw=10.0.50.254"

  sshkeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIgah15+jjufEiziZxhrmus/EVq9gPRqHMX5Ejl5dtWk angle"

  tags = format("agent;cluster%02s;debian;k3s;worker", 2)

  lifecycle {
    ignore_changes = [
      cipassword,
      network,
    ]
  }
}
