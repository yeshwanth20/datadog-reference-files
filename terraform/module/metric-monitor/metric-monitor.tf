# Create Datadog monitor resources for the given metrics
resource "datadog_monitor" "resource" {
  # Create a monitor resource for each metric specified in the var.metrics_monitor list
  count              = (var.metrics_monitor != null) ? length(var.metrics_monitor) : 0
  name               = var.metrics_monitor[count.index]["alert_name"]
  type               = var.metrics_monitor[count.index]["type"]
  message            = var.metrics_monitor[count.index]["priority"] == 3 || var.metrics_monitor[count.index]["priority"] == 4 ? replace(var.metrics_monitor[count.index]["message"], "@opsgenie-Notifier", "") : var.metrics_monitor[count.index]["message"]

  query = var.metrics_monitor[count.index]["query"]

  monitor_thresholds {
    warning           = lookup(var.metrics_monitor[count.index],"warning", null)
    warning_recovery  = lookup(var.metrics_monitor[count.index],"warning_recovery", null)
    critical          = lookup(var.metrics_monitor[count.index],"critical", null)
    ok                = lookup(var.metrics_monitor[count.index],"ok", null)
    critical_recovery = lookup(var.metrics_monitor[count.index],"critical_recovery", null)
  }
  notify_no_data    = var.notify_no_data
  renotify_interval = var.renotify_interval
  renotify_occurrences = var.renotify_occurrences

  notify_audit = var.notify_audit
  timeout_h    = var.timeout_h

  priority = var.metrics_monitor[count.index]["priority"]

  include_tags = var.include_tags
  tags = var.default_tags_kube_cluster 
}


