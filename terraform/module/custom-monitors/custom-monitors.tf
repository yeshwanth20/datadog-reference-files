resource "datadog_monitor" "custom_monitor" {
  for_each = {
    for custom in var.custom_monitors : custom.res_index => custom
    if custom.create_custom_monitor == true
  }
  name               = each.value.name
  type               = each.value.type
  message            = each.value.priority == 3 || each.value.priority == 4 ? replace(each.value.message, "@opsgenie-Notifier", "") :  each.value.message
  query              = each.value.query

  dynamic "monitor_thresholds" {
    for_each = each.value.monitor_threshold
    content { 
          critical = monitor_thresholds.value.critical
          critical_recovery = monitor_thresholds.value.critical_recovery
          warning = monitor_thresholds.value.warning
          warning_recovery = monitor_thresholds.value.warning_recovery
    }
  }

  notify_no_data    = each.value.notify_no_data
  renotify_interval = each.value.renotify_interval
  renotify_occurrences = each.value.renotify_occurrences

  notify_audit = each.value.notify_audit
  timeout_h    = each.value.timeout_h

  priority = each.value.priority

  include_tags = each.value.include_tags
  tags = each.value.tags
}

