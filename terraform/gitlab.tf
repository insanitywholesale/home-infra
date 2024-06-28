resource "proxmox_vm_qemu" "proxmox_vm_gitlab" {
  provider    = proxmox.pve01
  vmid        = 1045
  count       = 1
  name        = format("gitlab%02s", (count.index) + 1)
  desc        = format("GitLab server %02s", (count.index) + 1)
  target_node = "pve01"

  clone    = "deb12-tmpl"
  os_type  = "cloud-init"
  qemu_os  = "l26"
  cpu      = "SandyBridge"
  cores    = 4
  sockets  = 1
  memory   = 8192
  scsihw   = "virtio-scsi-pci"
  bootdisk = "virtio0"
  agent    = 1
  onboot   = true

  disk {
    virtio {
      virtio0 {
        size         = 60
        storage      = "local-lvm"
        storage_type = "virtio"
      }
    }
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  ipconfig0 = "ip=10.0.50.${(count.index) + 45}/24,gw=10.0.50.254"

  sshkeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIgah15+jjufEiziZxhrmus/EVq9gPRqHMX5Ejl5dtWk angle"

  tags = "debian;git;gitlab"

  lifecycle {
    ignore_changes = [
      cipassword,
      network,
    ]
  }
}

