resource "proxmox_vm_qemu" "proxmox_vm_pihole" {
  provider    = proxmox.pve1
  vmid        = 1002
  count       = 1
  name        = format("pihole%02svp", (count.index) + 1)
  desc        = format("pihole %02s", (count.index) + 1)
  target_node = "pve1"

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

  tags = "debian;dns;pihole"

  lifecycle {
    ignore_changes = [
      cipassword,
      network,
    ]
  }
}

