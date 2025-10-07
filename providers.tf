# =============================================================================
# TERRAFORM CONFIGURATION
# =============================================================================

terraform {
  required_version = ">= 1.10.0"

  required_providers {
    datadog = {
      source  = "DataDog/datadog"
      version = "3.57.0"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = "0.68.2"
    }
  }

  backend "remote" {
    # Configuration is provided via backend.conf file
  }
}

# =============================================================================
# PROVIDER VARIABLES
# =============================================================================

variable "api_key" {
  description = "Datadog API Key for authentication"
  type        = string
  sensitive   = true
}

variable "api_url" {
  description = "Datadog API URL endpoint"
  type        = string
}

variable "app_key" {
  description = "Datadog Application Key for authentication"
  type        = string
  sensitive   = true
}

variable "tfe_uri" {
  description = "Terraform Enterprise hostname/URI"
  type        = string
}

variable "tfe_token" {
  description = "Terraform Enterprise authentication token"
  type        = string
  sensitive   = true
}

# =============================================================================
# PROVIDER CONFIGURATIONS
# =============================================================================

provider "tfe" {
  hostname = var.tfe_uri
  token    = var.tfe_token
}

provider "datadog" {
  api_key = var.api_key
  api_url = var.api_url
  app_key = var.app_key
}
