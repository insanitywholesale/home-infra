provider "proxmox" {
    pm_tls_insecure = true
    pm_api_url = "https://192.168.7.137:8006/api2/json"
    pm_password = "failfail"
    pm_user = "root@pam"
}

resource "proxmox_lxc" "ubuntu_mysql_lxc" {
	count = 1
    features {
        nesting = true
    }

    hostname = "ubuntu-mysql-${count.index}"

	memory = 1024

    network {
        name = "eth0"
        bridge = "vmbr0"
        ip = "192.168.1.36/16,gw=192.168.0.1"
    }

	ssh_public_keys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC5jzKi37jm3517bqThbw+7LR/GXm3qC6Az5F+ZUa36vYM7Ygk2K5bWcFIL2YUCrkL5jfSsvoowONjCAxyuoyxtW4MJxnQLyq4u4yDsRC7YvBPAKZUYaHwnbkCfDs5a75dEFOoDxCA0DY2GrhqzBndaTcCfl0fZ4vN+9LcKOb1dSKiHeHvsh35YNtwntbL21meo+hiycUEgGwNe9/4kxKpdGTr7HvbeX2Fjm/UZBZIJKVcGop/3gCHXYnKH+OY5zc8cmt9Jg4CIwEqrSKeOX0bE8LSPRpVRXH4v8OcMaMei/HQejlH8NBwybEdJ4mhl8vHaFEjDbIWoOujmiRQF2263 angle@puddle"

    ostemplate = "local:vztmpl/ubuntu-18.04-standard_18.04.1-1_amd64.tar.gz"
    password = "failfail"
    storage = "local-lvm"
    target_node = "mobilepve"
    unprivileged = true
	start = true

}

resource "proxmox_lxc" "ubuntu_nginx_lxc" {

	count = 1

    features {
        nesting = true
    }

    hostname = "ubuntu-nginx-${count.index}"

	memory = 768

    network {
        name = "eth0"
        bridge = "vmbr0"
        ip = "192.168.6.80/16,gw=192.168.0.1"
    }

	ssh_public_keys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC5jzKi37jm3517bqThbw+7LR/GXm3qC6Az5F+ZUa36vYM7Ygk2K5bWcFIL2YUCrkL5jfSsvoowONjCAxyuoyxtW4MJxnQLyq4u4yDsRC7YvBPAKZUYaHwnbkCfDs5a75dEFOoDxCA0DY2GrhqzBndaTcCfl0fZ4vN+9LcKOb1dSKiHeHvsh35YNtwntbL21meo+hiycUEgGwNe9/4kxKpdGTr7HvbeX2Fjm/UZBZIJKVcGop/3gCHXYnKH+OY5zc8cmt9Jg4CIwEqrSKeOX0bE8LSPRpVRXH4v8OcMaMei/HQejlH8NBwybEdJ4mhl8vHaFEjDbIWoOujmiRQF2263 angle@puddle"

    ostemplate = "local:vztmpl/ubuntu-18.04-standard_18.04.1-1_amd64.tar.gz"
    password = "failfail"
    storage = "local-lvm"
    target_node = "mobilepve"
    unprivileged = true
	start = false

}
