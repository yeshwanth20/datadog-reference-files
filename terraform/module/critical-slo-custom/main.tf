
resource "datadog_service_level_objective" "slo_monitors_err" {
  for_each = {
    for slo in var.critical_error_slo : slo.res_index => slo
    if slo.create_slo == true
  }
  name        = each.value.alert_name
  type        = each.value.type
  description = each.value.description
  tags        = each.value.tags
  #monitor_ids = [for item in each.value.monitor_res_index: datadog_monitor.metrics_monitor[item].id]
  monitor_ids = each.value.monitor_ids

  dynamic "thresholds" {
    for_each = var.slo_thresholds.slo_timeframes
    content {
      timeframe = thresholds.value
      target    = var.slo_thresholds.slo_target_warn
      warning   = var.slo_thresholds.slo_warning
    }
  }
}


