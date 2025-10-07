terraform {
  required_providers {
    datadog = {
      source = "DataDog/datadog"
      version = "3.46.0"
    }
  }
}

variable "metrics_monitors" {
  type  = list(object({
    name    = string
    type    = string
    message = string
    query   = string

    monitor_threshold  = list(object({
      warning           = any
      warning_recovery  = any
      critical          = any
      critical_recovery = any
    }))

    include_tags            = bool
    notify_audit            = bool
    notify_no_data          = bool
    priority                = number
    renotify_interval       = number
    renotify_occurrences    = number
    timeout_h               = number
    tags                    = list(string)
    res_index               = string
    create_metrics_monitors = bool
  }))
  description = "metrics monitor configuration"
}

variable "critical_error_slo" {
  type  = list(object({
    create_slo  = bool
    res_index   = string
    alert_name  = string
    type        = string
    description = string
    monitor_ids = list(string)
    #monitor_res_index = list(string)
    tags        = list(string)
  }))
  description = "slo configuration"
  default = []
}

#Variables for SLO
variable "slo_thresholds" {
  type = object({
    slo_timeframes  = list(string)
    slo_target_warn = string
    slo_warning     = string
  })
  description = "Define threshold timeframes"
  default     = {
    slo_timeframes  = ["7d", "30d", "90d"]
    slo_target_warn = "98"
    slo_warning     = "99"
  }
}

