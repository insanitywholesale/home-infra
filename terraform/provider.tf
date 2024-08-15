terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc3"
    }
  }
  backend "http" {}
}

provider "proxmox" {
  pm_tls_insecure = true
  pm_api_url      = "https://pve.home.inherently.xyz/api2/json"
  pm_password     = "failfail"
  pm_user         = "root@pam"
  pm_timeout      = 900
  pm_debug        = true
}
