provider "proxmox" {
    pm_tls_insecure = true
    pm_api_url = "https://192.168.7.87:8006/api2/json"
    pm_password = "failfail"
    pm_user = "root@pam"
}

resource "proxmox_vm_qemu" "proxmox_vm_k3s" {

	count = 3
	name = "debk3s-${count.index}"
	target_node = "pve-0"

	clone = "debian-ci"
	os_type = "cloud-init"
	cores = 2
	sockets = "1"
	cpu = "host"
	memory = 1024
	scsihw = "virtio-scsi-pci"
	bootdisk = "scsi0"

	disk {
		id = 0
		size = 25
		type = "scsi"
		storage = "local-zfs"
		storage_type = "zfspool"
		iothread = true
		backup = false
	}

	network {
		id = 0
		model = "virtio"
		bridge = "vmbr0"
	}

	lifecycle {
		ignore_changes = [
			network,
		]
	}

	ipconfig0 = "ip=192.168.4.11${count.index + 1}/16,gw=192.168.0.1"

	sshkeys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC5jzKi37jm3517bqThbw+7LR/GXm3qC6Az5F+ZUa36vYM7Ygk2K5bWcFIL2YUCrkL5jfSsvoowONjCAxyuoyxtW4MJxnQLyq4u4yDsRC7YvBPAKZUYaHwnbkCfDs5a75dEFOoDxCA0DY2GrhqzBndaTcCfl0fZ4vN+9LcKOb1dSKiHeHvsh35YNtwntbL21meo+hiycUEgGwNe9/4kxKpdGTr7HvbeX2Fjm/UZBZIJKVcGop/3gCHXYnKH+OY5zc8cmt9Jg4CIwEqrSKeOX0bE8LSPRpVRXH4v8OcMaMei/HQejlH8NBwybEdJ4mhl8vHaFEjDbIWoOujmiRQF2263 angle@puddle"

}
