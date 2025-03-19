terraform {
  backend "gcs" {
    bucket = "dac-demo-tfstate"
    prefix = "terraform/state"
  }
}

provider "google-beta" {
  project = "micka-secops-lab" # Put your Project ID
  region  = "us-central1"      # Put the region you want to use by default => No impact for our example 
}

locals {
  rule_files = fileset("${path.module}/rules", "*.yaral")
  rules      = { for rule_file in local.rule_files : rule_file => file("${path.module}/rules/${rule_file}") }
}

resource "google_chronicle_rule" "chronicle_rules" {
  provider = google-beta
  for_each = local.rules
  #rule_id         = each.key
  location        = "Europe"                               # Put the location of your instance 
  instance        = "57f24a5e-1eb5-4f76-9793-80bd3c4b7825" # Put Secops SIEM ID 
  deletion_policy = "FORCE"
  text            = each.value
}

resource "google_chronicle_rule_deployment" "chronicle_rules_deployment" {
  provider = google-beta
  location = "Europe"                               # Put the location of your instance 
  instance = "57f24a5e-1eb5-4f76-9793-80bd3c4b7825" # Put Secops SIEM ID 
  for_each = local.rules
  rule = element(split("/", resource.google_chronicle_rule.chronicle_rules[each.key].name),
  length(split("/", resource.google_chronicle_rule.chronicle_rules[each.key].name)) - 1)
  # Get rule ID from google_chronicle_rule
  enabled       = true
  alerting      = true
  archived      = false
  run_frequency = "DAILY"
}

# Display key values
# output "rule_keys" {
#   value = keys(local.rules)
# }

