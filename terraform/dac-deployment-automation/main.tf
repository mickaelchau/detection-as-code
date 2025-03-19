locals {
  rule_files = fileset("${path.module}/rules", "*.yaral")
  rules      = { for rule_file in local.rule_files : rule_file => file("${path.module}/rules/${rule_file}") }
}


resource "google_chronicle_rule" "chronicle_rules" {
  provider = google-beta
  for_each = local.rules
  #rule_id         = each.key
  location        = var.secops_instance_region # Put the location of your instance 
  instance        = var.secops_instance_id     # Put Secops SIEM ID 
  deletion_policy = "FORCE"
  text            = each.value
}

resource "google_chronicle_rule_deployment" "chronicle_rules_deployment" {
  provider = google-beta
  location = var.secops_instance_region # Put the location of your instance 
  instance = var.secops_instance_id     # Put Secops SIEM ID 
  for_each = local.rules
  rule = element(split("/", resource.google_chronicle_rule.chronicle_rules[each.key].name),
  length(split("/", resource.google_chronicle_rule.chronicle_rules[each.key].name)) - 1)
  # Get rule ID from google_chronicle_rule
  enabled       = true
  alerting      = true
  archived      = false
  run_frequency = "DAILY"
}
