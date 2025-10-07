locals {
  custom_monitor = flatten([
    for team_index in var.custom_monitor_val : [
      for service in team_index.services : [
        for custom_monitor in service.custom_monitor : [
          for custom_envs in var.regions_envs :
          {
            name    = title("${custom_monitor.alert_name}")
            type    = "query alert"
            #message = "{{#is_alert}} ${custom_monitor.message}  {{/is_alert}} Notify: ${can("${custom_monitor.notify}") == false ? "@pagerduty-DD_DataPlatform_SRE" : " @pagerduty-DD_DataPlatform_SRE ${custom_monitor.notify}"}"
            message  = "{{#is_alert}} ${custom_monitor.message}  {{/is_alert}} Notify: ${can("${custom_monitor.notify}") == false ? " " : " ${custom_monitor.notify}"} ${custom_envs.env == "dev" || custom_envs.env == "qa" || custom_envs.env == "uat" ? "" : "@opsgenie-Notifier"} ${custom_envs.env == format("%s_%s", custom_envs.location, custom_envs.env) ? "@opsgenie-Notifier" : ""} ${custom_envs.env == "qa" || custom_envs.env == "stg" ? can("${custom_monitor.notify_non_prod}") == true ? custom_monitor.notify_non_prod : "" : "${custom_envs.env == "prod"}" ? can("${custom_monitor.notify_prod}") == true ? custom_monitor.notify_prod : "" : ""}"
            
            query = "${service.metrics_type}" == "nifi" || "${service.metrics_type}" == "custom" ? "${custom_envs.location}" == "global" ? "${custom_monitor.query}" : "${custom_monitor.enable_namespace_val}" == false ? replace("${custom_monitor.query}","kube_cluster_name:default","${format("kube_cluster_name:%s","${lookup(var.nifi_kube_cluster_name,"${"${custom_envs.env}" == "dev" || "${custom_envs.env}" == "qa" || "${custom_envs.env}" == "uat" ? "${custom_envs.env}" : "${format("%s_%s","${custom_envs.location}","${custom_envs.env}")}" }")}")}")  : replace("${custom_monitor.query}","kube_cluster_name:default","${format("kube_cluster_name:%s , kube_namespace:%s","${lookup(var.nifi_kube_cluster_name,"${"${custom_envs.env}" == "dev" || "${custom_envs.env}" == "qa" || "${custom_envs.env}" == "uat" ? "${custom_envs.env}" : "${format("%s_%s", "${custom_envs.location}", "${custom_envs.env}")}"}")}","${lookup(custom_monitor.namespace_val,"${"${custom_envs.env}" == "dev" || "${custom_envs.env}" == "qa" || "${custom_envs.env}" == "uat" ? "${custom_envs.env}" : "${format("%s_%s", "${custom_envs.location}", "${custom_envs.env}")}"}")}")}") : "${custom_envs.location}" == "global" ? "${custom_monitor.query}" : replace("${custom_monitor.query}","kube_namespace:default","${format("kube_namespace:%s","${lookup(var.kube_namespace_values,"${"${custom_envs.env}" == "dev" || "${custom_envs.env}" == "qa" || "${custom_envs.env}" == "uat" ? "${custom_envs.env}" : "${format("%s_%s","${custom_envs.location}","${custom_envs.env}")}"}")}")}")
            monitor_threshold = [{
              warning           = lookup(custom_monitor, "warning", null)
              warning_recovery  = lookup(custom_monitor, "warning_recovery", null)
              critical          = lookup(custom_monitor, "critical", null)
              critical_recovery = lookup(custom_monitor, "critical_recovery", null)
            }]
            res_index             = lower(replace("${service.name}_${custom_monitor.alert_name}_${custom_envs.location}_${custom_envs.env}", " ", "_"))
            #priority              = custom_monitor.priority
            priority              = "${length(custom_monitor.mon_priority) > 0 ? lookup(custom_monitor.mon_priority, "${custom_envs.env == "dev" || custom_envs.env == "qa" || custom_envs.env == "uat" ? custom_envs.env : format("%s_%s", custom_envs.location,custom_envs.env)}") : lookup(var.monitors_priority, "${custom_envs.env == "dev" || custom_envs.env == "qa" || custom_envs.env == "uat" ? custom_envs.env : format("%s_%s", custom_envs.location,custom_envs.env)}")}"
            include_tags          = true
            notify_no_data        = false
            renotify_interval     = 180
            renotify_occurrences  = 2
            notify_audit          = false
            timeout_h             = 1
            #create_custom_monitor = custom_envs.env == "prod" ? false : custom_envs.create_custom_monitor
            create_metrics_monitors = service.metrics_type == "nifi" && custom_envs.env == "dev" || (contains(var.exclude_custom_monitor_val["${custom_envs.location}_${custom_envs.env}"], custom_monitor.alert_name)  == true) ? "false" :  custom_envs.create_monitor
            tags = concat(
              [
                for tag in var.default_tags : 
                tag if !can(regex("value_stream", tag)) # Filter out value_stream from default_tags
              ],
              [
                "pwc_env:${custom_envs.env}",
                "pwc_territory:${custom_envs.location}",
                "pwc_type:integration",
                lower(replace(length(regexall("service", service.name)) > 0 ? "service:${service.name}" : "service:${service.name}-service", " ", "-")),
                lower("team:${lookup(var.team_names,"${team_index.team_name}")}"),
                "pwc_ciid:${lookup(service.tag_ciid, custom_envs.location)}",
                "value_stream:${lower(lookup(var.team_names, team_index.team_name)) == "captain_america" ? "gds" : "data_platform"}", # Conditional value_stream
              ],
              custom_envs.env == "prod" ? [ "pwc_integration:splunk" ] : []
            )

          }
        ]
      ]
    ]
  ])
}

# module "custom_monitor" {
#   source          = "././module/custom-monitor"
#   custom_monitors = local.custom_monitor
# }

module "custom_monitor" {
  source          = "././module/dd-metrics-monitor"
  metrics_monitors = local.custom_monitor
}


