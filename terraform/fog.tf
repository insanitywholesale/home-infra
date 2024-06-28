resource "proxmox_vm_qemu" "proxmox_vm_fog" {
  provider    = proxmox.pve02
  vmid        = 1007
  count       = 1
  name        = format("fog%02s", (count.index) + 1)
  desc        = format("FOG PXE server %02s", (count.index) + 1)
  target_node = "pve02"

  clone    = "deb11-tmpl"
  os_type  = "cloud-init"
  qemu_os  = "l26"
  cpu      = "SandyBridge"
  cores    = 1
  sockets  = 1
  memory   = 2048
  scsihw   = "virtio-scsi-pci"
  bootdisk = "virtio0"
  agent    = 1
  onboot   = true

  disk {
    virtio {
      virtio0 {
        size         = 30
        storage      = "local-lvm"
        storage_type = "virtio"
      }
    }
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  ipconfig0 = "ip=10.0.50.${(count.index) + 7}/24,gw=10.0.50.254"

  sshkeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIgah15+jjufEiziZxhrmus/EVq9gPRqHMX5Ejl5dtWk angle"

  tags = "debian;fog;pxe"

  lifecycle {
    ignore_changes = [
      cipassword,
      network,
    ]
  }
}

