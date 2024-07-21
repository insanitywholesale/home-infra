resource "proxmox_vm_qemu" "proxmox_vm_k3s_ha_masters" {
  count       = 3
  vmid        = 1051 + count.index
  name        = format("k3s-m%02s-c%02s", count.index + 1, 1)
  desc        = format("HA k3s server/master %02s for cluster %02s", count.index + 1, 1)
  target_node = format("pve%02s", (count.index % 3) + 1)

  clone    = "deb11-tmpl"
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
          size    = 40
          storage = "local-lvm"
        }
      }
    }
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  ipconfig0 = "ip=10.0.50.${51 + count.index}/24,gw=10.0.50.254"

  sshkeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIgah15+jjufEiziZxhrmus/EVq9gPRqHMX5Ejl5dtWk angle"

  tags = format("cluster%02s;debian;k3s;master;server", 1)

  lifecycle {
    ignore_changes = [
      cipassword,
      network,
    ]
  }
}
