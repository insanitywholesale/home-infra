resource "proxmox_vm_qemu" "proxmox_vm_k3s_ha_workers_2" {
  count       = 0
  vmid        = 1067 + count.index
  name        = format("k3s-w%02s-c%02s", count.index + 1, 2)
  desc        = format("HA k3s agent/worker %02s for cluster %02s", count.index + 1, 2)
  target_node = format("pve%02s", (count.index % 3) + 2)

  clone    = "deb12-tmpl"
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
    ide {
      ide3 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
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

  ipconfig0 = "ip=10.0.50.${67 + count.index}/24,gw=10.0.50.254"

  sshkeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIgah15+jjufEiziZxhrmus/EVq9gPRqHMX5Ejl5dtWk angle"

  tags = format("agent;cluster%02s;debian;k3s;worker", 2)

  lifecycle {
    ignore_changes = [
      cipassword,
      network,
    ]
  }
}
