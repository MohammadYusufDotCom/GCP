# ───────────────────────────────────────────────────────#
# 1. Regular on-demand pool (always 1 node, never dies)  #
# ───────────────────────────────────────────────────────#

resource "google_container_node_pool" "regular" {
  name     = "${var.cluster_name}-regular"
  location = var.region
  cluster  = google_container_cluster.primary.name

  # Fixed size – always exactly 1 node
  # node_count = 1        # we are using autoscaling
  # initial_node_count = 1  # this is the number of nodes per zone

  autoscaling {
    total_min_node_count = 1
    total_max_node_count = 2
    location_policy      = "ANY"
    # min_node_count = 1
    # max_node_count = 2
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  upgrade_settings {
    max_surge       = 1
    max_unavailable = 0
  }

  node_config {
    machine_type = var.machine_type
    disk_size_gb = var.disk_size_gb
    disk_type    = "pd-balanced"

    spot        = false # ← regular on-demand VMs
    preemptible = false # ← (default) but just to be explicit 

    service_account = google_service_account.gke_node.email
    # oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]  # because we are using workload_metadata_config in GKE

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    shielded_instance_config {
      enable_secure_boot          = true
      enable_integrity_monitoring = true
    }

    metadata = {
      disable-legacy-endpoints = "true"
    }
    tags = ["gke-node", "regular-pool", "internal"]
    labels = {
      "node-pool" = "regular"
    }
  }
}



# ──────────────────────────────────────────────────────────────────#
# 2. Spot pool (cheap & autoscaling – this one will be used first)  #
# ──────────────────────────────────────────────────────────────────#

resource "google_container_node_pool" "spot" {
  name     = "${var.cluster_name}-spot"
  location = var.region
  cluster  = google_container_cluster.primary.name

  # node_locations = [var.region]
  # image_type = "COS_CONTAINERD"    # for patch

  autoscaling {
    min_node_count = var.min_node_count
    max_node_count = var.max_node_count
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  upgrade_settings {
    max_surge       = 2
    max_unavailable = 0
  }

  node_config {
    machine_type = var.machine_type
    disk_size_gb = var.disk_size_gb
    disk_type    = "pd-standard"

    spot        = true  # ← THIS is the new 2025 way (replaces preemptible)
    preemptible = false # ← leave this out or false for spot VMs

    service_account = google_service_account.gke_node.email # service account for monitoring 
    # oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    metadata = {
      disable-legacy-endpoints = "true"
    }

    shielded_instance_config {
      enable_secure_boot          = true
      enable_integrity_monitoring = true
    }

    tags = ["gke-node", "spot-pool", "internal"]
    labels = {
      "node-pool"             = "spot"
      "cloud.google.com/spot" = "true" # helps with tooling
    }
  }
}