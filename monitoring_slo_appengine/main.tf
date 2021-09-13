data "google_monitoring_app_engine_service" "default" {
  module_id = "default"
}

resource "google_monitoring_slo" "appeng_slo" {
  service = data.google_monitoring_app_engine_service.default.service_id

  slo_id = "ae-slo-${local.name_suffix}"
  display_name = "Terraform Test SLO for App Engine"

  goal = 0.9
  calendar_period = "DAY"

  basic_sli {
    latency {
      threshold = "1s"
    }
  }
}
