resource "proxmox_vm_qemu" "proxmox_vm_k3s_one" {
  provider    = proxmox.pve03
  count       = 0
  vmid        = 1060
  name        = format("k3s-one-c%02s", 3)
  desc        = format("k3s single node, technically cluster %02s", 3)
  target_node = "pve03"

  clone    = "deb11-tmpl"
  os_type  = "cloud-init"
  qemu_os  = "l26"
  cpu      = "SandyBridge"
  cores    = 4
  sockets  = 1
  memory   = 10240
  scsihw   = "virtio-scsi-pci"
  bootdisk = "virtio0"
  agent    = 1
  onboot   = true

  disk {
    size    = "90G"
    type    = "virtio"
    storage = "local-lvm"
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  ipconfig0 = "ip=10.0.50.60/24,gw=10.0.50.254"

  sshkeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIgah15+jjufEiziZxhrmus/EVq9gPRqHMX5Ejl5dtWk angle"

  tags = format("agent;cluster%02s;debian;k3s;server;worker", 3)

  lifecycle {
    ignore_changes = [
      cipassword,
      network,
    ]
  }
}
