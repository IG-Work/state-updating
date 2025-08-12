terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "random" {}

resource "random_pet" "old_resource" {
  length    = 2
  separator = "-"
}
