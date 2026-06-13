# Terraform GCP IAM and Logging Security Alerting Module

This Terraform module sets up 7 critical Log-based Alert Policies in Google Cloud Platform (GCP) to monitor security events. It routes these alerts to a designated email notification channel.

## Alerts Monitored

1. **Cloud Logging Sink Modified or Deleted**: Watches for modifications to Cloud Logging Sinks (`CreateSink`, `UpdateSink`, `DeleteSink`).
2. **Service Account Created**: Alerts when a new Service Account is created.
3. **Service Account Key Created**: Alerts when a permanent JSON key is generated for a Service Account.
4. **Google Workspace User Created**: Watches `admin.googleapis.com` logs for user creation (requires Workspace logs routed to GCP).
5. **Console Login Failure or No MFA**: Monitors `login.googleapis.com` for failed logins or logins where `is_second_factor=false`.
6. **Firewall Rule Open to 0.0.0.0/0**: Triggers when a VPC Firewall Rule is inserted or patched to allow `0.0.0.0/0` source range.
7. **INCIDENT - External IAM Role Grant**: Triggers when an IAM policy binds a role to any `@gmail.com` account.
8. **New API Enabled**: Triggers when a new service/API is enabled in the project (`google.api.serviceusage.v1.ServiceUsage.EnableService` or `EnableServices`).
9. **Basic Role Granted**: Triggers when a primitive role (`roles/owner`, `roles/editor`, `roles/viewer`) is granted at the **project level**. (Does not trigger for service-level grants like on a specific GCS bucket or GCE instance).
10. **Billing Modified or Billing Role Granted**: Triggers on any mutating API calls to `cloudbilling.googleapis.com` or when an IAM role containing the word `billing` (e.g., `roles/billing.admin`, `roles/billing.user`) is granted.

## Usage Example

```hcl
module "security_alerting" {
  source = "./terraform_iam_alerting_module"

  project_id                 = "my-gcp-project-id"
  notification_email_address = "security-team@example.com"
  alert_prefix               = "[P0-SECURITY] "
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `project_id` | The ID of the GCP project. | `string` | n/a | yes |
| `notification_email_address` | The email address where alerts will be sent. | `string` | n/a | yes |
| `alert_prefix` | An optional prefix prepended to alert policy names. | `string` | `"[SECURITY] "` | no |

## Outputs

| Name | Description |
|------|-------------|
| `notification_channel_id` | The ID of the created email notification channel. |
| `alert_policy_ids` | A map of the created alert policy IDs. |
