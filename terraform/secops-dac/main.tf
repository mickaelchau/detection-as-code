provider "google-beta" {
  project = "micka-secops-lab"
  region  = "us-central1"
}

locals {
  rule_files = fileset("${path.module}/rules", "*.yaral")
  rules      = { for rule_file in local.rule_files : rule_file => file("${path.module}/rules/${rule_file}") }
}

resource "google_chronicle_rule" "chronicle_rules" {
  provider = google-beta
  for_each = local.rules
  #rule_id         = each.key
  location        = "Europe"
  instance        = "57f24a5e-1eb5-4f76-9793-80bd3c4b7825"
  deletion_policy = "FORCE"
  text            = each.value
}

resource "google_chronicle_rule_deployment" "chronicle_rules_deployment" {
  provider      = "google-beta"
  location      = "Europe"
  instance      = "57f24a5e-1eb5-4f76-9793-80bd3c4b7825"
  for_each      = local.rules
  rule          = element(split("/", resource.google_chronicle_rule.chronicle_rules[each.key].name), 
                  length(split("/", resource.google_chronicle_rule.chronicle_rules[each.key].name)) - 1)
  enabled       = true
  alerting      = true
  archived      = false
  run_frequency = "DAILY"
}

# Display key values
# output "rule_keys" {
#   value = keys(local.rules)
# }

