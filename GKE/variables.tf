variable "project_id" {
  description = "The GCP project ID"
  type        = string
  validation {
    condition     = length(var.project_id) > 0
    error_message = "Project ID cannot be empty."
  }
}

variable "region" {
  description = "The GCP region"
  type        = string
  default     = "us-centeral1" # Mumbai region
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "prod"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "gke-vpc"
}

variable "vpc_cidr" {
  description = "CIDR range for VPC"
  type        = string
  default     = "10.0.0.0/16"
  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "Must be a valid CIDR range."
  }
}

variable "subnet_cidr" {
  description = "CIDR range for subnet"
  type        = string
  default     = "10.0.0.0/24"
}

variable "subnet_secondary_cidr_pod" {
  description = "CIDR range for subnet"
  type        = string
  default     = "10.0.16.0/20"
}

variable "subnet_secondary_cidr_service" {
  description = "CIDR range for subnet"
  type        = string
  default     = "10.0.32.0/20"
}

variable "proxy_only_subnet_cidr" {
  description = "CIDR range for proxy-only subnet"
  type        = string
  default     = "10.0.64.0/24"
}

variable "ssh_allowed_cidr" {
  description = "CIDR range for allowed ssh access from"
  type        = string
  default     = "0.0.0.0/0"
}

variable "cluster_name" {
  description = "GKE cluster name"
  type        = string
  default     = "private-gke-cluster"
}

variable "gke_version" {
  description = "GKE cluster version"
  type        = string
  default     = "1.27"
}

variable "gke_master_ipv4_cidr" {
  description = "GKE Master ipv4 cidr range"
  type        = string
  default     = "172.0.0.0/28"
}

variable "min_node_count" {
  description = "Minimum number of nodes in node pool"
  type        = number
  default     = 1
}

variable "max_node_count" {
  description = "Maximum number of nodes in node pool"
  type        = number
  default     = 5
}

variable "machine_type" {
  description = "Machine type for nodes"
  type        = string
  default     = "e2-medium"
}

variable "disk_size_gb" {
  description = "Disk size for nodes in GB"
  type        = number
  default     = 50
}

## yusuf custer ipv4 cidr
variable "yusuf_ip" {
  description = "custum ip range for accessing cluster"
  type        = map(string)
  default = {
    all_allowed = "0.0.0.0/0"
  }
}
