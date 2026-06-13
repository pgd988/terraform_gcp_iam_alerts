resource "google_monitoring_notification_channel" "email" {
  project      = var.project_id
  display_name = "Security Alerts Email Channel"
  type         = "email"
  labels = {
    email_address = var.notification_email_address
  }
}

resource "google_monitoring_alert_policy" "logging_sink_modification" {
  project      = var.project_id
  display_name = "${var.alert_prefix}Cloud Logging Sink Modified or Deleted"
  combiner     = "OR"
  conditions {
    display_name = "Log match condition"
    condition_matched_log {
      filter = "protoPayload.serviceName=\"logging.googleapis.com\" AND protoPayload.methodName=(\"google.logging.v2.ConfigServiceV2.CreateSink\" OR \"google.logging.v2.ConfigServiceV2.UpdateSink\" OR \"google.logging.v2.ConfigServiceV2.DeleteSink\")"
    }
  }
  notification_channels = [google_monitoring_notification_channel.email.name]
  alert_strategy {
    notification_rate_limit {
      period = "300s"
    }
  }
}

resource "google_monitoring_alert_policy" "service_account_created" {
  project      = var.project_id
  display_name = "${var.alert_prefix}Service Account Created"
  combiner     = "OR"
  conditions {
    display_name = "Log match condition"
    condition_matched_log {
      filter = "protoPayload.methodName=\"google.iam.admin.v1.CreateServiceAccount\""
    }
  }
  notification_channels = [google_monitoring_notification_channel.email.name]
  alert_strategy {
    notification_rate_limit {
      period = "300s"
    }
  }
}

resource "google_monitoring_alert_policy" "service_account_key_created" {
  project      = var.project_id
  display_name = "${var.alert_prefix}Service Account Key Created"
  combiner     = "OR"
  conditions {
    display_name = "Log match condition"
    condition_matched_log {
      filter = "protoPayload.methodName=\"google.iam.admin.v1.CreateServiceAccountKey\""
    }
  }
  notification_channels = [google_monitoring_notification_channel.email.name]
  alert_strategy {
    notification_rate_limit {
      period = "300s"
    }
  }
}

resource "google_monitoring_alert_policy" "workspace_user_added" {
  project      = var.project_id
  display_name = "${var.alert_prefix}Google Workspace User Created"
  combiner     = "OR"
  conditions {
    display_name = "Log match condition"
    condition_matched_log {
      filter = "protoPayload.serviceName=\"admin.googleapis.com\" AND protoPayload.methodName=\"admin.directory.user.insert\""
    }
  }
  notification_channels = [google_monitoring_notification_channel.email.name]
  alert_strategy {
    notification_rate_limit {
      period = "300s"
    }
  }
}

resource "google_monitoring_alert_policy" "login_failure_or_no_mfa" {
  project      = var.project_id
  display_name = "${var.alert_prefix}Console Login Failure or No MFA"
  combiner     = "OR"
  conditions {
    display_name = "Log match condition"
    condition_matched_log {
      filter = "protoPayload.serviceName=\"login.googleapis.com\" AND (protoPayload.methodName=\"login_failure\" OR \"is_second_factor=false\")"
    }
  }
  notification_channels = [google_monitoring_notification_channel.email.name]
  alert_strategy {
    notification_rate_limit {
      period = "300s"
    }
  }
}

resource "google_monitoring_alert_policy" "firewall_rule_open_to_world" {
  project      = var.project_id
  display_name = "${var.alert_prefix}Firewall Rule Open to 0.0.0.0/0"
  combiner     = "OR"
  conditions {
    display_name = "Log match condition"
    condition_matched_log {
      filter = "resource.type=\"gce_firewall_rule\" AND protoPayload.methodName=(\"v1.compute.firewalls.insert\" OR \"v1.compute.firewalls.patch\") AND protoPayload.request.sourceRanges=\"0.0.0.0/0\""
    }
  }
  notification_channels = [google_monitoring_notification_channel.email.name]
  alert_strategy {
    notification_rate_limit {
      period = "300s"
    }
  }
}

resource "google_monitoring_alert_policy" "incident_external_iam_grant" {
  project      = var.project_id
  display_name = "${var.alert_prefix}INCIDENT - External IAM Role Grant (@gmail.com)"
  combiner     = "OR"
  conditions {
    display_name = "Log match condition"
    condition_matched_log {
      filter = "protoPayload.methodName=\"SetIamPolicy\" AND protoPayload.serviceData.policyDelta.bindingDeltas.member:\"@gmail.com\""
    }
  }
  notification_channels = [google_monitoring_notification_channel.email.name]
  alert_strategy {
    notification_rate_limit {
      period = "300s"
    }
  }
}

resource "google_monitoring_alert_policy" "api_enabled" {
  project      = var.project_id
  display_name = "${var.alert_prefix}New API Enabled in Project"
  combiner     = "OR"
  conditions {
    display_name = "Log match condition"
    condition_matched_log {
      filter = "protoPayload.serviceName=\"serviceusage.googleapis.com\" AND protoPayload.methodName=(\"google.api.serviceusage.v1.ServiceUsage.EnableService\" OR \"google.api.serviceusage.v1.ServiceUsage.EnableServices\")"
    }
  }
  notification_channels = [google_monitoring_notification_channel.email.name]
  alert_strategy {
    notification_rate_limit {
      period = "300s"
    }
  }
}

resource "google_monitoring_alert_policy" "basic_role_granted" {
  project      = var.project_id
  display_name = "${var.alert_prefix}Basic Role (Owner/Editor/Viewer) Granted"
  combiner     = "OR"
  conditions {
    display_name = "Log match condition"
    condition_matched_log {
      filter = "resource.type=\"project\" AND protoPayload.methodName=\"SetIamPolicy\" AND protoPayload.serviceData.policyDelta.bindingDeltas.action=\"ADD\" AND (protoPayload.serviceData.policyDelta.bindingDeltas.role=\"roles/owner\" OR protoPayload.serviceData.policyDelta.bindingDeltas.role=\"roles/editor\" OR protoPayload.serviceData.policyDelta.bindingDeltas.role=\"roles/viewer\")"
    }
  }
  notification_channels = [google_monitoring_notification_channel.email.name]
  alert_strategy {
    notification_rate_limit {
      period = "300s"
    }
  }
}

resource "google_monitoring_alert_policy" "billing_changes_or_roles" {
  project      = var.project_id
  display_name = "${var.alert_prefix}Billing Modified or Billing Role Granted"
  combiner     = "OR"
  conditions {
    display_name = "Log match condition"
    condition_matched_log {
      filter = "(protoPayload.serviceName=\"cloudbilling.googleapis.com\" AND NOT protoPayload.methodName:(\"Get\" OR \"List\")) OR (protoPayload.methodName=\"SetIamPolicy\" AND protoPayload.serviceData.policyDelta.bindingDeltas.action=\"ADD\" AND protoPayload.serviceData.policyDelta.bindingDeltas.role:\"billing\")"
    }
  }
  notification_channels = [google_monitoring_notification_channel.email.name]
  alert_strategy {
    notification_rate_limit {
      period = "300s"
    }
  }
}

resource "google_monitoring_alert_policy" "alert_policy_modified" {
  project      = var.project_id
  display_name = "${var.alert_prefix}Alert Policy or Notification Channel Modified"
  combiner     = "OR"
  conditions {
    display_name = "Log match condition"
    condition_matched_log {
      filter = <<EOF
protoPayload.serviceName="monitoring.googleapis.com" AND (
  (protoPayload.methodName=("google.monitoring.v3.AlertPolicyService.UpdateAlertPolicy" OR "google.monitoring.v3.AlertPolicyService.DeleteAlertPolicy") AND protoPayload.resourceName=("${google_monitoring_alert_policy.logging_sink_modification.name}" OR "${google_monitoring_alert_policy.service_account_created.name}" OR "${google_monitoring_alert_policy.service_account_key_created.name}" OR "${google_monitoring_alert_policy.workspace_user_added.name}" OR "${google_monitoring_alert_policy.login_failure_or_no_mfa.name}" OR "${google_monitoring_alert_policy.firewall_rule_open_to_world.name}" OR "${google_monitoring_alert_policy.incident_external_iam_grant.name}" OR "${google_monitoring_alert_policy.api_enabled.name}" OR "${google_monitoring_alert_policy.basic_role_granted.name}" OR "${google_monitoring_alert_policy.billing_changes_or_roles.name}"))
  OR (protoPayload.methodName=("google.monitoring.v3.NotificationChannelService.UpdateNotificationChannel" OR "google.monitoring.v3.NotificationChannelService.DeleteNotificationChannel") AND protoPayload.resourceName="${google_monitoring_notification_channel.email.name}")
)
EOF
    }
  }
  notification_channels = [google_monitoring_notification_channel.email.name]
  alert_strategy {
    notification_rate_limit {
      period = "300s"
    }
  }
}




