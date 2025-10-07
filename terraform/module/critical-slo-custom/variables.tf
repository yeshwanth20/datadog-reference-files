
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

