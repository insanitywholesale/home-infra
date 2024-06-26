resource "proxmox_vm_qemu" "proxmox_vm_powerdns" {
  vmid        = 1005
  count       = 0
  name        = format("powerdns%02s", (count.index) + 1)
  desc        = format("PowerDNS %02s", (count.index) + 1)
  target_node = "pve03"

  clone    = "deb11-tmpl"
  os_type  = "cloud-init"
  qemu_os  = "l26"
  cpu      = "SandyBridge"
  cores    = 1
  sockets  = 1
  memory   = 1536
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

  ipconfig0 = "ip=10.0.50.${(count.index) + 5}/24,gw=10.0.50.254"

  sshkeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIgah15+jjufEiziZxhrmus/EVq9gPRqHMX5Ejl5dtWk angle"

  tags = "debian;dns;powerdns"

  lifecycle {
    ignore_changes = [
      cipassword,
      network,
    ]
  }
}

