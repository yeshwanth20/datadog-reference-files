variable "custom_monitors" {
    type              = list(object({
    name              = string
    type              = string
    message           = string
    query             = string
    monitor_threshold = list(object({
        critical          = any
        critical_recovery = any
        warning           = any
        warning_recovery  = any
    }))
    notify_no_data        = bool
    renotify_interval     = number
    renotify_occurrences  = number
    notify_audit          = bool
    timeout_h             = number
    priority              = number
    include_tags          = bool
    tags                  = list(string)
    res_index             = string
    create_custom_monitor = bool
  }))
  description = "Custom monitor configuration"
}