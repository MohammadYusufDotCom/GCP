output "vpc_name" {
  description = "The name of the VPC"
  value       = google_compute_network.vpc.name
}

output "subnet_name" {
  description = "The name of the subnet"
  value       = google_compute_subnetwork.subnet.name
}

output "cluster_name" {
  description = "GKE cluster name"
  value       = google_container_cluster.primary.name
}

output "cluster_location" {
  description = "GKE cluster location"
  value       = google_container_cluster.primary.location
}

output "cluster_endpoint" {
  description = "GKE cluster endpoint"
  value       = google_container_cluster.primary.endpoint
  sensitive   = true
}

output "cluster_ca_certificate" {
  description = "Cluster CA certificate"
  value       = google_container_cluster.primary.master_auth[0].cluster_ca_certificate
  sensitive   = true
}

output "service_account_email" {
  description = "GKE node service account email"
  value       = google_service_account.gke_node.email
}

output "nat_gateway_ip" {
  description = "Cloud NAT gateway IP addresses"
  value       = google_compute_router_nat.nat.nat_ip_allocate_option == "MANUAL_ONLY" ? google_compute_router_nat.nat.nat_ips : null
}