terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "random" {}

# Toggle to enable or disable resource creation
variable "enable_random" {
  description = "Toggle to enable random name generation"
  type        = bool
  default     = true
}

# Conditional Random ID (only created if enabled)
resource "random_id" "server_id" {
  count       = var.enable_random ? 1 : 0
  byte_length = 4
}

# Random Pet name for the server
resource "random_pet" "server_name" {
  length    = 2
  separator = "-"
}

# Null resource that simulates a deployment, triggered by random values
resource "null_resource" "deploy_server" {
  # This will recreate the null_resource every time the random_id or random_pet changes
  triggers = {
    server_id   = var.enable_random ? random_id.server_id[0].hex : "disabled"
    server_name = random_pet.server_name.id
  }

  provisioner "local-exec" {
    command = "echo Deploying server ${self.triggers.server_name}-${self.triggers.server_id}"
  }
}

output "server_full_name" {
  value = "${random_pet.server_name.id}-${var.enable_random ? random_id.server_id[0].hex : "disabled"}"
}
