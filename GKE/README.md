# GCP GKE Private Cluster with Terraform

## Overview
This Terraform configuration creates a secure, private GKE cluster in GCP with best practices.

## Features
- Private GKE cluster with private nodes and endpoint
- Custom VPC with Mumbai region subnet
- CIDR range: 10.0.0.0/16 (Class A) to avoid conflicts
- Auto-scaling node pool
- Cloud NAT for outbound internet access
- Workload Identity enabled
- Shielded nodes for security

## Prerequisites
1. GCP account with project created
2. Terraform installed (>= 1.0)
3. gcloud CLI installed and authenticated
4. Enable required APIs: