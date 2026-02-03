# Create VPC
resource "google_compute_network" "vpc" {
  name                    = "${var.vpc_name}-${var.environment}"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
  mtu                     = 1460

  # lifecycle {
  #   prevent_destroy = true # Safety guard to prevent accidental deletion
  # }
  description = "VPC for GKE cluster in ${var.environment} environment"
}

# Create subnet in Mumbai region
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.vpc_name}-subnet-${var.environment}"
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc.id

  private_ip_google_access = true # Enable private Google access

  secondary_ip_range {
    range_name    = "pod-range"
    ip_cidr_range = var.subnet_secondary_cidr_pod #"10.12.16.0/20" # For GKE pods
  }

  secondary_ip_range {
    range_name    = "service-range"
    ip_cidr_range = var.subnet_secondary_cidr_service #"10.12.32.0/20" # For GKE services
  }
  description = "Subnet for GKE cluster in ${var.environment} environment"
}

# Create proxy-only subnet for managed proxies (like Envoy)
resource "google_compute_subnetwork" "proxy_only_subnet" {
  name          = "${local.project_tags.project}-proxy-only-subnet-${var.environment}"
  ip_cidr_range = var.proxy_only_subnet_cidr #"10.12.60.0/23"
  region        = var.region
  purpose       = "REGIONAL_MANAGED_PROXY" # For Envoy proxies
  role          = "ACTIVE"
  network       = google_compute_network.vpc.id
}

# Cloud Router for Cloud NAT
resource "google_compute_router" "router" {
  name    = "${local.project_tags.project}-cloud-router-${var.environment}"
  region  = var.region
  network = google_compute_network.vpc.id
}

# Cloud NAT for private nodes to access internet
resource "google_compute_router_nat" "nat" {
  name                               = "${local.project_tags.project}-cloud-nat-${var.environment}"
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.subnet.id
    source_ip_ranges_to_nat = ["PRIMARY_IP_RANGE", "LIST_OF_SECONDARY_IP_RANGES"]
    secondary_ip_range_names = [
      google_compute_subnetwork.subnet.secondary_ip_range[0].range_name,
      google_compute_subnetwork.subnet.secondary_ip_range[1].range_name
    ]
  }

  min_ports_per_vm = 512 # Good practice for GKE 2048 for prod --- keep it 512 for dev env

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

# Firewall rule for internal communication
resource "google_compute_firewall" "internal" {
  name    = "${local.project_tags.project}-allow-internal-${var.environment}"
  network = google_compute_network.vpc.name

  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  source_ranges = [var.vpc_cidr]

  # Safety: Don't apply to internet-facing instances
  target_tags = ["internal"]

  description = "Allow internal communication within VPC and tagged resources only"
}

# Firewall rule for SSH (restrictive)
resource "google_compute_firewall" "ssh" {
  name    = "allow-ssh-${var.environment}"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  # Restrict to specific IP ranges (update with your IP)
  source_ranges = [var.ssh_allowed_cidr] #["0.0.0.0/0"] # WARNING: Change this to your specific IP range

  # Safety: Only apply to instances with specific tag # any of them has
  target_tags = ["bastion", "management"]

  description = "Allow SSH access from office IP ranges to tagged instances only i.e bastion host"
}