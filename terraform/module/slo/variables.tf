variable "include_tags" {
  type        = bool
  default     = true
  description = "whether notifications from this monitor automatically insert its triggering tags into the title"
}

variable "slo_list" {
  type  = list(object({
    create_slo        = bool
    res_index         = string
    alert_name        = string
    type              = string
    description       = string
    numerator_query   = string
    denominator_query = string
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
