
locals {
  team_kube_monitor = flatten([
    for teams in var.team_kube_monitors : [
      for metrics_type in teams.metrics_type : [ 
        for metrics in metrics_type.metrics_detail : [     
          for log_envs in var.regions_envs_team : {
              name = title("${metrics.alert_name} for ${lookup(var.team_names,"${teams.team_name}")} - ${log_envs.location}${log_envs.env}")

              type = strcontains(metrics.alert_name, "Pod restart") ? "event-v2 alert" : "metric alert"
              
              message = "{{#is_alert}} ${metrics.message}  {{/is_alert}} \n {{#is_recovery}} ${metrics.recovery_message}  {{/is_recovery}} \n Notify: ${can("${metrics.notify}") == false ? " " : " ${metrics.notify}"} ${log_envs.env == "dev" || log_envs.env == "qa"? "" : "@opsgenie-Notifier"} ${log_envs.env == format("%s_%s", log_envs.location, log_envs.env) ? "@opsgenie-Notifier" : ""} ${log_envs.env == "qa" || log_envs.env == "stg" ? can("${metrics.notify_non_prod}") == true ? metrics.notify_non_prod : "" : "${log_envs.env == "prod"}" ? can("${metrics.notify_prod}") == true ? metrics.notify_prod : "" : ""}"

              query = "${metrics_type.metrics_name}" == "service" ? can("${metrics.namespace}") && "${metrics.namespace}" != null ? replace("${metrics.query}","kube_namespace:default","${format("kube_namespace:%s","${lookup(metrics.namespace,"${"${log_envs.env}" == "stg" || "${log_envs.env}" == "prod"  ? format("%s_%s","${log_envs.location}","${log_envs.env}") :"${log_envs.env}"}")}")}") : replace("${metrics.query}","kube_namespace:default","${format("kube_namespace:%s","${lookup(var.kube_namespace_team_values,"${"${log_envs.env}" == "stg" || "${log_envs.env}" == "prod"  ? format("%s_%s","${log_envs.location}","${log_envs.env}") :"${log_envs.env}"}")}")}") : "${metrics_type.metrics_name}" == "nifi" ?  replace("${metrics.query}","kube_cluster_name:default","${format("kube_cluster_name:%s","${lookup(var.nifi_kube_cluster_team_name,"${"${log_envs.env}" == "stg" || "${log_envs.env}" == "prod"  ? format("%s_%s","${log_envs.location}","${log_envs.env}") : "${log_envs.env}"}")}")}") : replace("${metrics.query}","kube_cluster_name:default","${format("kube_cluster_name:%s","${lookup(var.dp_kube_cluster_team_name,"${"${log_envs.env}" == "stg" || "${log_envs.env}" == "prod"  ? format("%s_%s","${log_envs.location}","${log_envs.env}") : "${log_envs.env}"}")}")}")    
              
              monitor_threshold = [
                {
                  warning           = can("${metrics.warning}") == true ? "${metrics.warning}" : null
                  warning_recovery  = can("${metrics.warning_recovery}") == true ? "${metrics.warning_recovery}" : null
                  critical          = can("${metrics.critical}") == true ? "${metrics.critical}" : null
                  critical_recovery = can("${metrics.critical_recovery}") == true ? "${metrics.critical_recovery}" : null
                }
              ]
                
              res_index = lower(replace("${metrics_type.metrics_name}_${lookup(var.team_names,"${teams.team_name}")}_${metrics.alert_name}_${log_envs.location}_${log_envs.env}", " ", "_"))

              priority                = "${length(metrics.mon_priority) > 0 ? lookup(metrics.mon_priority, "${log_envs.env == "dev" || log_envs.env == "qa" || log_envs.env == "uat" ? log_envs.env : format("%s_%s", log_envs.location,log_envs.env)}") : lookup(var.monitors_priority, "${log_envs.env == "dev" || log_envs.env == "qa" || log_envs.env == "uat" ? log_envs.env : format("%s_%s", log_envs.location,log_envs.env)}")}"
              
              include_tags            = true
              notify_no_data          = false
              renotify_interval       = 180
              renotify_occurrences    = 2
              notify_audit            = false
              timeout_h               = 1
              include_tags            = true

              create_metrics_monitors = contains(var.exclude_team_kube_monitors["${log_envs.location}_${log_envs.env}"], "${teams.team_name}_${metrics_type.metrics_name}_${metrics.alert_name}")  == true ? "false" : "${log_envs.create_monitor}"    
                
              tags = concat(
                [
                  for tag in var.default_tags : 
                  tag if !can(regex("value_stream", tag)) # Filter out value_stream from default_tags
                ],
                [
                  "pwc_env:${log_envs.env}",
                  "${log_envs.location == "we" ? "pwc_territory:eu" : "pwc_territory:${log_envs.location}"}",
                  "pwc_type:infra-monitor",
                  lower("team:${lookup(var.team_names, "${teams.team_name}")}"),
                  "pwc_ciid:${lookup(metrics.tag_ciid, log_envs.location)}",
                  "value_stream:${lower(lookup(var.team_names, teams.team_name)) == "captain_america" ? "gds" : "data_platform"}", # Conditional value_stream
                  
                ],
                log_envs.env == "prod" ? ["pwc_integration:splunk"] : []
              )
            }
        ]
      ]
    ] 
  ]  
  )
}

module "kube_alert_team" {
  source           = "././module/dd-metrics-monitor"
  metrics_monitors = local.team_kube_monitor
}

