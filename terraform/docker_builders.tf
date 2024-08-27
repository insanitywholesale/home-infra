resource "proxmox_vm_qemu" "proxmox_vm_docker_builders" {
  count       = 2
  vmid        = 1141 + count.index
  name        = format("docker-builder%02s", count.index + 1)
  desc        = format("Docker buildx remote builder %02s", count.index + 1)
  target_node = format("pve%02s", (count.index % 3) + 1)

  clone    = "deb12-tmpl"
  os_type  = "cloud-init"
  qemu_os  = "l26"
  cpu      = "SandyBridge"
  cores    = 2
  sockets  = 1
  memory   = 2560
  scsihw   = "virtio-scsi-pci"
  bootdisk = "virtio0"
  agent    = 1
  onboot   = true

  disks {
    ide {
      ide3 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
    virtio {
      virtio0 {
        disk {
          size    = 40
          storage = "local-lvm"
        }
      }
    }
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  ipconfig0 = "ip=10.0.50.${141 + count.index}/24,gw=10.0.50.254"

  sshkeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIgah15+jjufEiziZxhrmus/EVq9gPRqHMX5Ejl5dtWk angle"

  tags = "builder;docker"

  lifecycle {
    ignore_changes = [
      cipassword,
      network,
    ]
  }
}
