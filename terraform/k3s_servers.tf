resource "proxmox_vm_qemu" "proxmox_vm_k3s_ha_masters_0" {
  provider    = proxmox.pve0
  count       = 1
  vmid        = 1000 + (count.index * 2) + 51
  name        = "k3sserver${(count.index * 2) + 1}vp"
  desc        = "HA k3s cluster master ${(count.index * 2) + 1}"
  target_node = "pve0"

  clone    = "deb11-tmpl"
  os_type  = "cloud-init"
  cpu      = "SandyBridge"
  cores    = 2
  sockets  = 1
  memory   = 4096
  scsihw   = "virtio-scsi-pci"
  bootdisk = "virtio0"
  agent    = 1
  onboot   = true

  disk {
    size    = "40G"
    type    = "virtio"
    storage = "local-lvm"
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  ipconfig0 = "ip=10.0.50.${(count.index * 2) + 51}/24,gw=10.0.50.254"

  sshkeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIgah15+jjufEiziZxhrmus/EVq9gPRqHMX5Ejl5dtWk angle"

  lifecycle {
    ignore_changes = [
      cipassword,
      network,
      desc,
    ]
  }
}

resource "proxmox_vm_qemu" "proxmox_vm_k3s_ha_masters_1" {
  provider    = proxmox.pve1
  count       = 1
  vmid        = 1000 + (count.index * 2) + 52
  name        = "k3sserver${(count.index * 2) + 2}vp"
  desc        = "HA k3s cluster master ${(count.index * 2) + 2}"
  target_node = "pve1"

  clone    = "deb11-tmpl"
  os_type  = "cloud-init"
  cpu      = "SandyBridge"
  cores    = 2
  sockets  = 1
  memory   = 4096
  scsihw   = "virtio-scsi-pci"
  bootdisk = "virtio0"
  agent    = 1
  onboot   = true

  disk {
    size    = "40G"
    type    = "virtio"
    storage = "local-lvm"
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  ipconfig0 = "ip=10.0.50.${(count.index * 2) + 52}/24,gw=10.0.50.254"

  sshkeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIgah15+jjufEiziZxhrmus/EVq9gPRqHMX5Ejl5dtWk angle"

  lifecycle {
    ignore_changes = [
      cipassword,
      network,
      desc,
    ]
  }
}
resource "proxmox_vm_qemu" "proxmox_vm_k3s_ha_masters_2" {
  provider    = proxmox.pve2
  count       = 1
  vmid        = 1000 + (count.index * 2) + 53
  name        = "k3sserver${(count.index * 2) + 3}vp"
  desc        = "HA k3s cluster master ${(count.index * 2) + 3}"
  target_node = "pve2"

  clone    = "deb11-tmpl"
  os_type  = "cloud-init"
  cpu      = "SandyBridge"
  cores    = 2
  sockets  = 1
  memory   = 4096
  scsihw   = "virtio-scsi-pci"
  bootdisk = "virtio0"
  agent    = 1
  onboot   = true

  disk {
    size    = "40G"
    type    = "virtio"
    storage = "local-lvm"
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  ipconfig0 = "ip=10.0.50.${(count.index * 2) + 53}/24,gw=10.0.50.254"

  sshkeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIgah15+jjufEiziZxhrmus/EVq9gPRqHMX5Ejl5dtWk angle"

  lifecycle {
    ignore_changes = [
      cipassword,
      network,
      desc,
    ]
  }
}