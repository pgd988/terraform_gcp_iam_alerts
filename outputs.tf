output "notification_channel_id" {
  description = "The ID of the created email notification channel."
  value       = google_monitoring_notification_channel.email.id
}

output "alert_policy_ids" {
  description = "The IDs of the created alert policies."
  value = {
    logging_sink_modification   = google_monitoring_alert_policy.logging_sink_modification.id
    service_account_created     = google_monitoring_alert_policy.service_account_created.id
    service_account_key_created = google_monitoring_alert_policy.service_account_key_created.id
    workspace_user_added        = google_monitoring_alert_policy.workspace_user_added.id
    login_failure_or_no_mfa     = google_monitoring_alert_policy.login_failure_or_no_mfa.id
    firewall_rule_open_to_world = google_monitoring_alert_policy.firewall_rule_open_to_world.id
    incident_external_iam_grant = google_monitoring_alert_policy.incident_external_iam_grant.id
    api_enabled                 = google_monitoring_alert_policy.api_enabled.id
    basic_role_granted          = google_monitoring_alert_policy.basic_role_granted.id
    billing_changes_or_roles    = google_monitoring_alert_policy.billing_changes_or_roles.id
  }
}



