terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = ">=1.29.4" # latest at the time of writing
    }
  }
}

provider "linode" {
  # token = "" # can be set using the LINODE_TOKEN env var
}

resource "linode_instance" "debian-eu-central" {
  # image = "linode/debian11" # should not be set when importing
  label  = "debian-eu-central"
  region = "eu-central"
  type   = "g6-standard-1"
}
