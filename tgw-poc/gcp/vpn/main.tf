resource "google_compute_router" "this" {
  name    = var.router_name
  region  = var.region
  network = var.network
  project = var.project_id

  bgp {
    asn = "64519"
  }
}
