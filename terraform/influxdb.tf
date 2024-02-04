resource "proxmox_vm_qemu" "proxmox_vm_influxdb" {
  provider    = proxmox.pve0
  vmid        = 1028
  count       = 1
  name        = format("influxdb%02s", (count.index) + 1)
  desc        = format("InfluxDB %02s", (count.index) + 1)
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
    size    = "50G"
    type    = "virtio"
    storage = "local-lvm"
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  ipconfig0 = "ip=10.0.50.${(count.index) + 28}/24,gw=10.0.50.254"

  sshkeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIgah15+jjufEiziZxhrmus/EVq9gPRqHMX5Ejl5dtWk angle"

  tags = "debian;influxdb;monitoring"

  lifecycle {
    ignore_changes = [
      cipassword,
      network,
    ]
  }
}

