resource "proxmox_vm_qemu" "proxmox_vm_postgres" {
  provider    = proxmox.pve0
  vmid        = 1020
  count       = 1
  name        = format("postgres%02svp", (count.index) + 1)
  desc        = "main VM for postgres"
  target_node = "pve0"

  clone    = "deb11-tmpl"
  os_type  = "cloud-init"
  qemu_os  = "l26"
  cpu      = "SandyBridge"
  cores    = 2
  sockets  = 1
  memory   = 2048
  scsihw   = "virtio-scsi-pci"
  bootdisk = "virtio0"
  agent    = 1
  onboot   = true

  disk {
    size    = "60G"
    type    = "virtio"
    storage = "local-lvm"
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  ipconfig0 = "ip=10.0.50.${(count.index) + 20}/24,gw=10.0.50.254"

  sshkeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIgah15+jjufEiziZxhrmus/EVq9gPRqHMX5Ejl5dtWk angle"

  tags = "debian;postgres"

  lifecycle {
    ignore_changes = [
      cipassword,
      network,
    ]
  }
}

