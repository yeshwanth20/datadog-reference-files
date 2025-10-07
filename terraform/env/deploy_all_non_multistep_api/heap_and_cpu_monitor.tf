locals {
  # Building the list of all Heap Monitors
  heap_monitor = flatten([
    for team_index in var.heap_monitor_val : [
      for service in team_index.services : [
        for heap_monitor in service.heap_monitor : [
          for heap_envs in var.regions_envs :
          {
            name    = title("${heap_monitor.alert_name}")
            type    = "query alert"
            message = "{{#is_alert}} ${heap_monitor.message} {{/is_alert}} Notify: ${can("${heap_monitor.notify}") == false ?   " " : " ${heap_monitor.notify}"} ${heap_envs.env == "dev" || heap_envs.env == "qa" || heap_envs.env == "uat" ? "" : "@opsgenie-Notifier"} ${heap_envs.env == "qa" || heap_envs.env == "stg" ? can("${heap_monitor.notify_non_prod}") == true ? heap_monitor.notify_non_prod : "" : "${heap_envs.env == "prod"}" ? can("${heap_monitor.notify_prod}") == true ? heap_monitor.notify_prod : "" : ""}"
            query   = "avg(last_5m):avg:kubernetes.memory.usage{kube_namespace:${lookup(var.kube_namespace_values, "${heap_envs.env}" == "dev" || "${heap_envs.env}" == "qa" || "${heap_envs.env}" == "uat" ? "${heap_envs.env}" : join("_",["${heap_envs.location}","${heap_envs.env}"]))},service:${service.name}} / avg:kubernetes.memory.limits{kube_namespace:${lookup(var.kube_namespace_values, "${heap_envs.env}" == "dev" || "${heap_envs.env}" == "qa" || "${heap_envs.env}" == "uat" ? "${heap_envs.env}" : join("_",["${heap_envs.location}","${heap_envs.env}"]))},service:${service.name}} > ${heap_monitor.critical}"
            monitor_threshold = [{
              warning           = lookup(heap_monitor, "warning", null)
              warning_recovery  = lookup(heap_monitor, "warning_recovery", null)
              critical          = lookup(heap_monitor, "critical", null)
              critical_recovery = lookup(heap_monitor, "critical_recovery", null)
            }]
            res_index               = lower(replace("${service.name}_${heap_monitor.alert_name}_${heap_envs.location}_${heap_envs.env}", " ", "_"))
            #priority                = "${heap_monitor.priority}"
            priority              = "${length(heap_monitor.mon_priority) > 0 ? lookup(heap_monitor.mon_priority, "${heap_envs.env == "dev" || heap_envs.env == "qa" || heap_envs.env == "uat" ? heap_envs.env : format("%s_%s", heap_envs.location,heap_envs.env)}") : lookup(var.monitors_priority, "${heap_envs.env == "dev" || heap_envs.env == "qa" || heap_envs.env == "uat" ? heap_envs.env : format("%s_%s", heap_envs.location,heap_envs.env)}")}"
            include_tags            = true
            notify_no_data          = false
            renotify_interval       = 180
            renotify_occurrences    = 2
            notify_audit            = false
            timeout_h               = 1
            # create_metrics_monitors = heap_envs.env == "prod" ? false : heap_envs.create_monitor
            create_metrics_monitors = contains(var.exclude_heap_monitor_val["${heap_envs.location}_${heap_envs.env}"], service.name)  == true ? "false" :  heap_envs.create_monitor

            tags = concat(
              [
                for tag in var.default_tags : 
                tag if !can(regex("value_stream", tag)) # Filter out value_stream from default_tags
              ],
              [
                "pwc_env:${heap_envs.env}",
                "pwc_territory:${heap_envs.location}",
                "pwc_type:metric",
                lower(replace(length(regexall("service", service.name)) > 0 ? "service:${service.name}" : "service:${service.name}-service", " ", "-")),
                lower("team:${lookup(var.team_names, "${team_index.team_name}")}"),
                "pwc_ciid:${lookup(service.tag_ciid, heap_envs.location)}",
                "value_stream:${lower(lookup(var.team_names, team_index.team_name)) == "captain_america" ? "gds" : "data_platform"}", # Conditional value_stream
              ],
              heap_envs.env == "prod" ? ["pwc_integration:splunk"] : []
            )

          }
        ]
      ]
    ]
  ])
}

locals {
  # Building the list of all CPU Monitors
  cpu_monitor = flatten([
    for team_index in var.cpu_monitor_val : [
      for service in team_index.services : [
        for cpu_monitor in service.cpu_monitor : [
          for cpu_envs in var.regions_envs :
          {
            name    = title("${cpu_monitor.alert_name}")
            type    = "query alert"
            message = "{{#is_alert}} ${cpu_monitor.message} {{/is_alert}} Notify: ${can("${cpu_monitor.notify}") == false ? " " : " ${cpu_monitor.notify}"} ${cpu_envs.env == "dev" || cpu_envs.env == "qa" || cpu_envs.env == "uat" ? "" : "@opsgenie-Notifier"} ${cpu_envs.env == "qa" || cpu_envs.env == "stg" ? can("${cpu_monitor.notify_non_prod}") == true ? cpu_monitor.notify_non_prod : "" : "${cpu_envs.env == "prod"}" ? can("${cpu_monitor.notify_prod}") == true ? cpu_monitor.notify_prod : "" : ""}"
            query   = "avg(last_5m):avg:kubernetes.cpu.usage.total{kube_namespace:${lookup(var.kube_namespace_values, "${cpu_envs.env}" == "dev" || "${cpu_envs.env}" == "qa"  || "${cpu_envs.env}" == "uat" ? "${cpu_envs.env}" : join("_",["${cpu_envs.location}","${cpu_envs.env}"]))},service:${service.name}} / (avg:kubernetes.cpu.limits{kube_namespace:${lookup(var.kube_namespace_values, "${cpu_envs.env}" == "dev" || "${cpu_envs.env}" == "qa" || "${cpu_envs.env}" == "uat" ? "${cpu_envs.env}" : join("_",["${cpu_envs.location}","${cpu_envs.env}"]))},service:${service.name}} * 1000000000) > ${cpu_monitor.critical}"
            monitor_threshold = [{
              warning           = lookup(cpu_monitor, "warning", null)
              warning_recovery  = lookup(cpu_monitor, "warning_recovery", null)
              critical          = lookup(cpu_monitor, "critical", null)
              critical_recovery = lookup(cpu_monitor, "critical_recovery", null)
            }]
            res_index               = lower(replace("${service.name}_${cpu_monitor.alert_name}_${cpu_envs.location}_${cpu_envs.env}", " ", "_"))
            priority                = "${cpu_monitor.priority}"
            #priority              = "${length(cpu_monitor.mon_priority) > 0 ? lookup(cpu_monitor.mon_priority, "${cpu_envs.env == "dev" || cpu_envs.env == "qa" || cpu_envs.env == "uat" ? cpu_envs.env : format("%s_%s", cpu_envs.location,cpu_envs.env)}") : lookup(var.monitors_priority, "${cpu_envs.env == "dev" || cpu_envs.env == "qa" || cpu_envs.env == "uat" ? cpu_envs.env : format("%s_%s", cpu_envs.location,cpu_envs.env)}")}"
            include_tags            = true
            notify_no_data          = false
            renotify_interval       = 180
            renotify_occurrences    = 2
            notify_audit            = false
            timeout_h               = 1
            # create_metrics_monitors = cpu_envs.env == "prod" ? false : cpu_envs.create_monitor
            create_metrics_monitors = contains(var.exclude_cpu_monitor_val["${cpu_envs.location}_${cpu_envs.env}"], service.name)  == true ? "false" :  cpu_envs.create_monitor

            tags = concat(
              var.default_tags,
              [
                "pwc_env:${cpu_envs.env}",
                "pwc_territory:${cpu_envs.location}",
                "pwc_type:metric",
                lower(replace(length(regexall("service", service.name)) > 0 ? "service:${service.name}" : "service:${service.name}-service", " ", "-")),
                lower("team:${lookup(var.team_names,"${team_index.team_name}")}"),                
                "pwc_ciid:${lookup(service.tag_ciid, cpu_envs.location)}",
              ],
              cpu_envs.env == "prod" ? ["pwc_integration:splunk" ]: [],
            )
          }
        ]
      ]
    ]
  ])
}

module "heap_monitor" {
  source           = "././module/dd-metrics-monitor"
  metrics_monitors = local.heap_monitor
}

module "cpu_monitor" {
  source           = "././module/dd-metrics-monitor"
  metrics_monitors = local.cpu_monitor
}


