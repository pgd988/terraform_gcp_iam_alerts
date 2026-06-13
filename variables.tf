variable "project_id" {
  description = "The ID of the GCP project where the alert policies and notification channel will be created."
  type        = string
}

variable "notification_email_address" {
  description = "The email address where the security alerts will be sent."
  type        = string
}

variable "alert_prefix" {
  description = "An optional prefix to prepend to the names of the created alert policies."
  type        = string
  default     = "[SECURITY] "
}
