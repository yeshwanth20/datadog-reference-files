locals {
  # Building the list of all log monitor - all teams, all regions and all services
  cdf_nifi_log_monitor = flatten([
    for team_index in var.cdf_nifi_log_monitors_val : [
      for service in team_index.services : [
        for log_monitor in service.log_monitor : [
          for log_envs in var.regions_envs :
          {
            #name    = title("${log_monitor.alert_name} - ${upper(log_envs.location)}-${upper(log_envs.env)}")
            name = title("${log_monitor.alert_name} - ${upper(log_envs.location == "eu" ? "we" : log_envs.location)}-${upper(log_envs.env == "stg" ? "stage" : log_envs.env)}")
            type    = "log alert"
            message = "{{#is_alert}} ${log_monitor.message}  {{/is_alert}} \n\n Notify: ${can("${log_monitor.notify}") == false ? "" : "${log_monitor.notify}"} ${log_envs.env == "dev" || log_envs.env == "qa" || log_envs.env == "uat" ? "" : "@opsgenie-Notifier"} ${log_envs.env == format("%s_%s", log_envs.location, log_envs.env) ? "@opsgenie-Notifier" : ""} ${log_envs.env == "qa" || log_envs.env == "stg" ? can("${log_monitor.notify_non_prod}") == true ? log_monitor.notify_non_prod : "" : "${log_envs.env == "prod"}" ? can("${log_monitor.notify_prod}") == true ? log_monitor.notify_prod : "" : ""}"
            query = can("${log_monitor.custom_query}") && can("${log_monitor.custom_query}") == true ? "${trimprefix("${log_monitor.query}", "logs(\"")}" : ("${log_envs.location}" == "us" || "${log_envs.location}" == "au" || "${log_envs.location}" == "sg" || "${log_envs.location}" == "eu") ? format("logs(\"pwc_env:%s pwc_region:%s %s", "${log_envs.env}" == "stg" ? "stage" : "${log_envs.env}", "${log_envs.location}" == "eu" ? "we" : "${log_envs.location}", "${trimprefix("${log_monitor.query}", "logs(\"")}") : format("logs(\"pwc_env:%s pwc_region:%s %s", "${log_envs.env}" == "stg" ? "stage" : "${log_envs.env}", "${log_envs.location}", "${trimprefix("${log_monitor.query}", "logs(\"")}")
            #query = can("${log_monitor.custom_query}") && can("${log_monitor.custom_query}") == true ? "${trimprefix("${log_monitor.query}", "logs(\"")}" : format("logs(\"pwc_env:%s pwc_region:%s %s %s\").index(\"*\").rollup(\"count\").by(\"%s\").last(\"1m\") > 1", "${log_envs.env}" == "stg" ? "stage" : "${log_envs.env}", "${log_envs.location}" == "eu" ? "we" : "${log_envs.location}", "${trimprefix("${log_monitor.query}", "logs(\"")}", "${log_envs.env}" == "qa" ? "@attributes.createdBy_username:* @attributes.createdBy_email:*" : "", "${log_envs.env}" == "qa" ? "@attributes.eventType @attributes.createdBy_username @attributes.createdBy_email" : "@attributes.eventType")
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
            create_metrics_monitors = contains(var.exclude_cdf_nifi_log_monitor["${log_envs.location}_${log_envs.env}"], service.name)  == true ? "false" : "${log_envs.create_monitor}"

            tags = concat(
              [
                for tag in var.default_tags : 
                tag if !can(regex("value_stream", tag)) # Filter out value_stream from default_tags
              ],
              [
                "pwc_env:${log_envs.env == "stg" ? "stage" : log_envs.env}",
                "${log_envs.location == "eu" ? "pwc_territory:we" : "pwc_territory:${log_envs.location}"}",
                lower(replace(length(regexall("service", service.name)) > 0 ? "service:${service.name}" : "service:${service.name}", " ", "-")),
                "pwc_type:log",
                lower("team:${lookup(var.team_names,"${team_index.team_name}")}"),
                "pwc_ciid:${lookup(service.tag_ciid, log_envs.location)}",
                "value_stream:${lower(lookup(var.team_names, team_index.team_name)) == "captain_america" ? "gds" : "data_platform"}", # Conditional value_stream
              ]
            )

          }
        ]
      ]
    ]
  ])

}
module "cdf_nifi_log_monitor" {
  source           = "././module/dd-metrics-monitor"
  metrics_monitors = local.cdf_nifi_log_monitor
}


