resource "proxmox_vm_qemu" "proxmox_vm_k3s_ha_masters_0_cluster_2" {
  provider    = proxmox.pve0
  count       = 1
  vmid        = 1000 + (count.index * 3) + 54
  name        = format("k3s-m%02s-c%02s", (count.index * 3) + 1, 2)
  desc        = format("HA k3s server/master %02s for cluster %02s", (count.index * 3) + 1, 2)
  target_node = "pve0"

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

  disk {
    size    = "40G"
    type    = "virtio"
    storage = "local-lvm"
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  ipconfig0 = "ip=10.0.50.${(count.index * 3) + 54}/24,gw=10.0.50.254"

  sshkeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIgah15+jjufEiziZxhrmus/EVq9gPRqHMX5Ejl5dtWk angle"

  tags = format("cluster%02s;debian;k3s;master;server", 2)

  lifecycle {
    ignore_changes = [
      cipassword,
      network,
    ]
  }
}

resource "proxmox_vm_qemu" "proxmox_vm_k3s_ha_masters_1_cluster_2" {
  provider    = proxmox.pve1
  count       = 1
  vmid        = 1000 + (count.index * 3) + 55
  name        = format("k3s-m%02s-c%02s", (count.index * 3) + 2, 2)
  desc        = format("HA k3s server/master %02s for cluster %02s", (count.index * 3) + 2, 2)
  target_node = "pve1"

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

  disk {
    size    = "40G"
    type    = "virtio"
    storage = "local-lvm"
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  ipconfig0 = "ip=10.0.50.${(count.index * 3) + 52}/24,gw=10.0.50.254"

  sshkeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIgah15+jjufEiziZxhrmus/EVq9gPRqHMX5Ejl5dtWk angle"

  tags = format("cluster%02s;debian;k3s;master;server", 2)

  lifecycle {
    ignore_changes = [
      cipassword,
      network,
    ]
  }
}

resource "proxmox_vm_qemu" "proxmox_vm_k3s_ha_masters_2_cluster_2" {
  provider    = proxmox.pve2
  count       = 1
  vmid        = 1000 + (count.index * 3) + 56
  name        = format("k3s-m%02s-c%02s", (count.index * 3) + 3, 2)
  desc        = format("HA k3s server/master %02s for cluster %02s", (count.index * 3) + 3, 2)
  target_node = "pve2"

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

  disk {
    size    = "40G"
    type    = "virtio"
    storage = "local-lvm"
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  ipconfig0 = "ip=10.0.50.${(count.index * 3) + 53}/24,gw=10.0.50.254"

  sshkeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIgah15+jjufEiziZxhrmus/EVq9gPRqHMX5Ejl5dtWk angle"

  tags = format("cluster%02s;debian;k3s;master;server", 2)

  lifecycle {
    ignore_changes = [
      cipassword,
      network,
    ]
  }
}
