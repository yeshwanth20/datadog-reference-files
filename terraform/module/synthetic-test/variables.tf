variable "include_tags" {
  type        = bool
  default     = true
  description = "whether notifications from this monitor automatically insert its triggering tags into the title"
}

variable "synthetic_tests" {
  type  = list(object({
    locations = list(string)
    res_index = string
    name      = string
    app_url   = string
    status    = string
    message   = string
    priority  = number
    test_data = object({
      follow_redirects   = bool
      accept_self_signed = bool
      test_type          = string
      test_subtype       = string
      test_method        = string
      tick_interval      = number
      test_port          = number
      retry              = object({
        count             = number
        interval          = number
        renotify_interval = number
      })
      assertions = list(object({
        type     = string
        operator = string
        target   = number
      }))
    })
    tags        = list(string)
    create_test = bool
  }))
  description = "Synthetic test application configuration details"
}

variable "slo_monitors" {
  type  = list(object({
    create_slo  = bool
    res_index   = string
    alert_name  = string
    type        = string
    description = string
    tags        = list(string)
  }))
  description = "slo configuration"
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


