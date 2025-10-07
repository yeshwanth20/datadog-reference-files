resource "datadog_monitor" "metrics_monitor" {
  for_each = {
    for metrics_monitors in var.metrics_monitors : metrics_monitors.res_index => metrics_monitors
    if metrics_monitors.create_metrics_monitors == true
  }
  name    = each.value.name
  type    = each.value.type
  message = each.value.priority == 3 || each.value.priority == 4 ? replace(each.value.message, "@opsgenie-Notifier", "") :  each.value.message
  query   = each.value.query

  dynamic "monitor_thresholds" {
    for_each = each.value.monitor_threshold
    content {
      warning           = monitor_thresholds.value.warning
      warning_recovery  = monitor_thresholds.value.warning_recovery
      critical          = monitor_thresholds.value.critical
      critical_recovery = monitor_thresholds.value.critical_recovery
    }
  }

  include_tags         = each.value.include_tags
  notify_audit         = each.value.notify_audit
  notify_no_data       = each.value.notify_no_data
  priority             = each.value.priority
  renotify_interval    = each.value.renotify_interval
  renotify_occurrences = each.value.renotify_occurrences
  timeout_h            = each.value.timeout_h
  tags                 = each.value.tags
}

resource "datadog_service_level_objective" "slo_monitors_err" {
  for_each = {
    for slo in var.critical_error_slo : slo.res_index => slo...
    if slo.create_slo == true
  }
  name        = each.value[0].alert_name  
  type        = each.value[0].type  
  description = each.value[0].description  
  tags        = each.value[0].tags  
  monitor_ids = each.value[0].monitor_ids  

  dynamic "thresholds" {
    for_each = var.slo_thresholds.slo_timeframes
    content {
      timeframe = thresholds.value
      target    = var.slo_thresholds.slo_target_warn
      warning   = var.slo_thresholds.slo_warning
    }
  }
}


