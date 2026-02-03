# Create private GKE cluster
resource "google_container_cluster" "primary" {
  name       = "${var.cluster_name}-${var.environment}"
  location   = var.region
  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name

  # Enable private cluster
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false                    # We can set it to false for using IAP (Identity Aware Proxy)
    master_ipv4_cidr_block  = var.gke_master_ipv4_cidr # Master CIDR (different from VPC range)
  }

  # Master authorized networks (for accessing cluster endpoint)
  master_authorized_networks_config {
    # cidr_blocks {                              # Leave empty for full private access, or add specific CIDRs
    #   cidr_block   = var.gke_allow_access_cidr # "0.0.0.0/0" || for using IAP (identity aware proxy) use ip-range -> 35.235.240.0/20
    #   display_name = "all-for-now"             # WARNING: Restrict this in production
    # }
    dynamic "cidr_blocks" {
      for_each = var.yusuf_ip
      content {
        cidr_block   = cidr_blocks.value # Yusuf's IP
        display_name = "${cidr_blocks.key} ip range for cluster access"
      }
    }
  }

  # Enable IP aliasing for pods and services
  ip_allocation_policy {
    cluster_secondary_range_name  = google_compute_subnetwork.subnet.secondary_ip_range[0].range_name
    services_secondary_range_name = google_compute_subnetwork.subnet.secondary_ip_range[1].range_name
  }

  # Enable Gateway API
  gateway_api_config {
    channel = "CHANNEL_STANDARD" # Use latest stable Gateway API
  }

  addons_config {
    http_load_balancing {
      disabled = false # Required for GKE Gateway controller
    }
  }

  # Remove default node pool
  remove_default_node_pool = true
  initial_node_count       = 1

  # Security settings
  enable_shielded_nodes       = true
  enable_intranode_visibility = true

  # Release channel for automatic updates
  release_channel {
    channel = "REGULAR"
  }

  # Maintenance window
  maintenance_policy {
    daily_maintenance_window {
      start_time = "03:00" # 3 AM IST
    }
  }

  # Workload Identity (Best Practice)
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  # Vertical Pod Autoscaling if needed
  vertical_pod_autoscaling {
    enabled = true
  }

  deletion_protection = false # set to true in production

  lifecycle {
    ignore_changes = [
      node_pool # Managed separately

      # (deprecated master auth) Use Workload Identity instead 
      #master_auth 
    ]
  }
}