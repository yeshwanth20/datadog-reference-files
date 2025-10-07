
variable "include_tags" {
  type        = bool
  default     = true
  description = "whether notifications from this monitor automatically insert its triggering tags into the title"
}

variable "notify_no_data" {
  type        = bool
  default     = false
  description = "A boolean indicating whether this monitor will notify when data stops reporting"
}
variable "notify_audit" {
  type        = bool
  default     = false
  description = "A boolean indicating whether tagged users will be notified on changes to this monitor"
}
variable "renotify_interval" {
  type        = number
  default     = 180
  description = "The number of minutes after the last notification before a monitor will re-notify on the current status. It will only re-notify if it's not resolved."
}

variable "timeout_h" {
  type        = number
  default     = 1
  description = "The number of hours of the monitor not reporting data before it will automatically resolve from a triggered state."
}

variable "metrics_monitor" {
  type = any
  description = "metrics application configuration details"
}

variable "default_tags_kube_cluster" {
  type = any
  description = "Add default tags for Kube Cluster Monitors"
}

variable "renotify_occurrences" {
  type        = number
  default     = 2
  description = "The number of re-notification messages that should be sent on the current status."
}


