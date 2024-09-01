resource "proxmox_vm_qemu" "proxmox_vm_k3s_ha_workers" {
  count       = 3
  vmid        = 1061 + count.index
  name        = format("k3s-w%02s", count.index + 1)
  desc        = format("HA k3s agent/worker %02s", count.index + 1)
  target_node = format("pve%02s", (count.index % 3) + 1)

  clone    = "deb12-tmpl"
  os_type  = "cloud-init"
  qemu_os  = "l26"
  cpu      = "SandyBridge"
  cores    = 2
  sockets  = 1
  memory   = 4096
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

  ipconfig0 = "ip=10.0.50.${61 + count.index}/24,gw=10.0.50.254"

  sshkeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIgah15+jjufEiziZxhrmus/EVq9gPRqHMX5Ejl5dtWk angle"

  tags = "agent;debian;k3s;worker"

  lifecycle {
    ignore_changes = [
      cipassword,
      network,
    ]
  }
}
