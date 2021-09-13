resource "google_ml_engine_model" "default" {
  name        = "terraform_test"
  description = "terraform_test"
  regions     = ["us-central1"]
  labels = {
    my_model = "foo"
  }
  online_prediction_logging         = true
  online_prediction_console_logging = true
}
