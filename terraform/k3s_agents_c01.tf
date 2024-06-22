resource "proxmox_vm_qemu" "proxmox_vm_k3s_ha_workers_0" {
  provider    = proxmox.pve01
  count       = 1
  vmid        = 1000 + (count.index * 3) + 61
  name        = format("k3s-w%02s-c%02s", (count.index * 3) + 1, 1)
  desc        = format("HA k3s agent/worker %02s for cluster %02s", (count.index * 3) + 1, 1)
  target_node = "pve01"

  clone    = "deb11-tmpl"
  os_type  = "cloud-init"
  qemu_os  = "l26"
  cpu      = "SandyBridge"
  cores    = 2
  sockets  = 1
  memory   = 3072
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

  ipconfig0 = "ip=10.0.50.${(count.index * 3) + 61}/24,gw=10.0.50.254"

  sshkeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIgah15+jjufEiziZxhrmus/EVq9gPRqHMX5Ejl5dtWk angle"

  tags = format("agent;cluster%02s;debian;k3s;worker", 1)

  lifecycle {
    ignore_changes = [
      cipassword,
      network,
    ]
  }
}

resource "proxmox_vm_qemu" "proxmox_vm_k3s_ha_workers_1" {
  provider    = proxmox.pve02
  count       = 1
  vmid        = 1000 + (count.index * 3) + 62
  name        = format("k3s-w%02s-c%02s", (count.index * 3) + 2, 1)
  desc        = format("HA k3s agent/worker %02s for cluster %02s", (count.index * 3) + 2, 1)
  target_node = "pve02"

  clone    = "deb11-tmpl"
  os_type  = "cloud-init"
  qemu_os  = "l26"
  cpu      = "SandyBridge"
  cores    = 2
  sockets  = 1
  memory   = 3072
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

  ipconfig0 = "ip=10.0.50.${(count.index * 3) + 62}/24,gw=10.0.50.254"

  sshkeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIgah15+jjufEiziZxhrmus/EVq9gPRqHMX5Ejl5dtWk angle"

  tags = format("agent;cluster%02s;debian;k3s;worker", 1)

  lifecycle {
    ignore_changes = [
      cipassword,
      network,
    ]
  }
}

resource "proxmox_vm_qemu" "proxmox_vm_k3s_ha_workers_2" {
  provider    = proxmox.pve03
  count       = 1
  vmid        = 1000 + (count.index * 3) + 63
  name        = format("k3s-w%02s-c%02s", (count.index * 3) + 3, 1)
  desc        = format("HA k3s agent/worker %02s for cluster %02s", (count.index * 3) + 3, 1)
  target_node = "pve03"

  clone    = "deb11-tmpl"
  os_type  = "cloud-init"
  qemu_os  = "l26"
  cpu      = "SandyBridge"
  cores    = 2
  sockets  = 1
  memory   = 3072
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

  ipconfig0 = "ip=10.0.50.${(count.index * 3) + 63}/24,gw=10.0.50.254"

  sshkeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIgah15+jjufEiziZxhrmus/EVq9gPRqHMX5Ejl5dtWk angle"

  tags = format("agent;cluster%02s;debian;k3s;worker", 1)

  lifecycle {
    ignore_changes = [
      cipassword,
      network,
    ]
  }
}
