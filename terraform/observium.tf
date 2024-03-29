resource "proxmox_vm_qemu" "proxmox_vm_observium" {
  provider    = proxmox.pve2
  vmid        = 1034
  count       = 1
  name        = format("observium%02s", (count.index) + 1)
  desc        = format("Observium %02s", (count.index) + 1)
  target_node = "pve2"

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

  disk {
    size    = "50G"
    type    = "virtio"
    storage = "local-lvm"
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  ipconfig0 = "ip=10.0.50.${(count.index) + 34}/24,gw=10.0.50.254"

  sshkeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIgah15+jjufEiziZxhrmus/EVq9gPRqHMX5Ejl5dtWk angle"

  tags = "debian;monitoring;observium"

  lifecycle {
    ignore_changes = [
      cipassword,
      network,
    ]
  }
}

