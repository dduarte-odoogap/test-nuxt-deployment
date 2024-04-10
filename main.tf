terraform {
  required_version = ">= 0.13"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0.0"
    }
  }
}

# Configure the Google Cloud Provider
provider "google" {
  project = "my-nuxt-redis-test-app"
  region  = "europe-west3"
  credentials = file("/home/dd/.config/gcloud/application_default_credentials.json")
}

# Enable the Compute Engine API
resource "google_project_service" "compute" {
  service = "compute.googleapis.com"
  disable_on_destroy = false
}

# Enable the Cloud Run API
resource "google_project_service" "run" {
  service = "run.googleapis.com"
  disable_on_destroy = false
}

# Enable the VPC Access API
resource "google_project_service" "vpcaccess" {
  service = "vpcaccess.googleapis.com"
  disable_on_destroy = false
}

# Enable the Redis API for Memorystore
resource "google_project_service" "redis" {
  service = "redis.googleapis.com"
  disable_on_destroy = false
}

# Create a Google VPC Network (optional, only if needed for isolation or specific networking requirements)
resource "google_compute_network" "vpc_network" {
  name                    = "my-vpc-network"
  auto_create_subnetworks = "false"
  depends_on = [google_project_service.compute]
}

# Create a subnet within the VPC network
resource "google_compute_subnetwork" "subnet" {
  name          = "my-subnet"
  ip_cidr_range = "10.0.0.0/16"
  network       = google_compute_network.vpc_network.self_link
}

# Create a Memorystore for Redis instance
resource "google_redis_instance" "cache" {
  name     = "my-redis-cache"
  tier     = "STANDARD_HA" # Choose based on your load and redundancy needs
  memory_size_gb = 1

  # Link to VPC Network
  authorized_network = google_compute_network.vpc_network.self_link
}

# Create a Serverless VPC Access connector for Cloud Run to access Memorystore
resource "google_vpc_access_connector" "vpc_connector" {
  name = "my-vpc-connector"
  network = google_compute_network.vpc_network.name
  ip_cidr_range = "10.8.0.0/28"
}

locals {
  redis_url = "redis://${google_redis_instance.cache.host}:${var.redis_port}"
}

variable "redis_port" {
  description = "The port on which the Redis instance listens"
  default     = "6379"
}

# Define Cloud Run service
resource "google_cloud_run_service" "nuxt_app" {
  name     = "my-nuxt-app"
  location = "europe-west3"
  depends_on = [google_vpc_access_connector.vpc_connector]

  template {
    spec {
      containers {
        image = "gcr.io/my-nuxt-redis-test-app/simple-nuxt-redis:1.1"

        # Define environment variables for Nuxt.js to connect to Redis
        env {
          name  = "REDIS_URL"
          value = local.redis_url
        }
      }
    }

    metadata {
      annotations = {
        "run.googleapis.com/vpc-access-connector" = google_vpc_access_connector.vpc_connector.name
      }
    }
  }

  # Configure network for VPC Access
  traffic {
    percent = 100
  }

  autogenerate_revision_name = true
}

resource "google_cloud_run_service_iam_member" "public_invoker" {
  location = "europe-west3"
  project  = "my-nuxt-redis-test-app"
  service  = "my-nuxt-app"

  role    = "roles/run.invoker"
  member  = "allUsers"
}
