terraform {
  required_providers {
    newrelic = {
      source = "newrelic/newrelic"
    }
  }
}

provider "newrelic" {
  account_id = "4268441"
  api_key    = "NRAK-SDFW9HJZ2M3OWF1R5ECVYISCL2Q"
  region     = "US"
}
