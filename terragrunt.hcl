remote_state {
  backend = "gcs"
  config = {
    bucket = "tfstate.parker.gg"
    prefix = "rke"
    skip_bucket_creation = true
  }
}

terraform {
  source = "./tf//src"
}
