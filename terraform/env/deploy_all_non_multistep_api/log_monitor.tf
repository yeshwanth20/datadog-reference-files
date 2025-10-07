locals {
  # Building the list of all log monitor - all teams, all regions and all services
  log_monitor = flatten([
    for team_index in var.log_monitors_val : [
      for service in team_index.services : [
        for log_monitor in service.log_monitor : [
          for log_envs in var.regions_envs :
          {
            name    = title("${log_monitor.alert_name}")
            type    = "log alert"
            message = "{{#is_alert}} ${log_monitor.message}  {{/is_alert}} Notify: ${can("${log_monitor.notify}") == false ? " " : " ${log_monitor.notify}"} ${log_envs.env == "dev" || log_envs.env == "qa" || log_envs.env == "uat" ? "" : "@opsgenie-Notifier"} ${log_envs.env == format("%s_%s", log_envs.location, log_envs.env) ? "@opsgenie-Notifier" : ""} ${log_envs.env == "qa" || log_envs.env == "stg" ? can("${log_monitor.notify_non_prod}") == true ? log_monitor.notify_non_prod : "" : "${log_envs.env == "prod"}" ? can("${log_monitor.notify_prod}") == true ? log_monitor.notify_prod : "" : ""}"

            query   = can("${log_monitor.custom_query}") && can("${log_monitor.custom_query}") == true ? length(regexall("(?i)mfe", service.name)) > 0 ? replace(format("logs(\"%s ", "${trimprefix("${log_monitor.query}", "logs(\"")}"), "kube_namespace:default", "kube_namespace:${lookup(var.mfe_kube_namespace_values, "${log_envs.env == "dev" || log_envs.env == "qa" ? log_envs.env : format("%s_%s", log_envs.location,log_envs.env)}")}") : replace(format("logs(\"%s ", "${trimprefix("${log_monitor.query}", "logs(\"")}"), "kube_namespace:default", "kube_namespace:${lookup(var.kube_namespace_values, "${log_envs.env == "dev" || log_envs.env == "qa" ? log_envs.env : format("%s_%s", log_envs.location,log_envs.env)}")}") : "${log_envs.location}" == "us" || "${log_envs.location}" == "eu" || "${log_envs.location}" == "au" || "${log_envs.location}" == "sg" ? format("logs(\"%s %s ", join(":",["kube_namespace",lookup(var.kube_namespace_values, "${log_envs.env}" == "dev" || "${log_envs.env}" == "qa" || "${log_envs.env}" == "uat"? "${log_envs.env}" : join("_",["${log_envs.location}","${log_envs.env}"]))]) , "${trimprefix("${log_monitor.query}", "logs(\"")}") : format("logs(\"%s ", "${trimprefix("${log_monitor.query}", "logs(\"")}")

            monitor_threshold = [{
              warning           = can("${log_monitor.warning}") == true ? "${log_monitor.warning}" : null
              warning_recovery  = can("${log_monitor.warning_recovery}") == true ? "${log_monitor.warning_recovery}" : null
              critical          = can("${log_monitor.critical}") == true ? "${log_monitor.critical}" : null
              critical_recovery = can("${log_monitor.critical_recovery}") == true ? "${log_monitor.critical_recovery}" : null
              }
            ]
            res_index               = lower(replace("${service.name}_${log_monitor.alert_name}_${log_envs.location}_${log_envs.env}", " ", "_"))
            priority                = "${log_monitor.priority}"
            #priority                = "${length("${log_monitor.mon_priority}") > 0 ? lookup("${log_monitor.mon_priority}", "${"${log_envs.env}" == "dev" || "${log_envs.env}" == "qa" || "${log_envs.env}" == "uat" ? "${log_envs.env}" : join("_",["${log_envs.location}","${log_envs.env}"])}") : lookup("${var.monitors_priority}", "${"${log_envs.env}" == "dev" || "${log_envs.env}" == "qa" || "${log_envs.env}" == "uat" ? "${log_envs.env}" : join("_",["${log_envs.location}","${log_envs.env}"])}")}"            
            include_tags            = true
            notify_no_data          = false
            renotify_interval       = 180
            renotify_occurrences    = 2
            notify_audit            = false
            timeout_h               = 1
            include_tags            = true
            # create_metrics_monitors = log_envs.env == "prod" ? false : log_envs.create_monitor
            create_metrics_monitors = contains(var.exclude_log_monitor["${log_envs.location}_${log_envs.env}"], service.name)  == true ? "false" : "${log_envs.create_monitor}"

            tags = concat(
              [
                for tag in var.default_tags : 
                tag if !can(regex("value_stream", tag)) # Filter out value_stream from default_tags
              ],
              [
                "pwc_env:${log_envs.env}",
                "${log_envs.location == "we" ? "pwc_territory:eu" : "pwc_territory:${log_envs.location}"}",
                lower(replace(length(regexall("service", service.name)) > 0 ? "service:${service.name}" : "service:${service.name}-service", " ", "-")),
                "pwc_type:log",
                lower("team:${lookup(var.team_names, "${team_index.team_name}")}"),
                "pwc_ciid:${lookup(service.tag_ciid, log_envs.location)}",
                "value_stream:${lower(lookup(var.team_names, team_index.team_name)) == "captain_america" ? "gds" : "data_platform"}", # Conditional value_stream
              ],
              log_envs.env == "prod" ? ["pwc_integration:splunk"] : []
            )

          }
        ]
      ]
    ]
  ])

}
module "log_monitor" {
  source           = "././module/dd-metrics-monitor"
  metrics_monitors = local.log_monitor
}



