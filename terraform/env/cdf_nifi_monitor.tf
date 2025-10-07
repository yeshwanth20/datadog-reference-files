locals {
  # Building the list of all metric monitors for CDF NiFi flows
  cdf_metric_monitor = flatten([
    for team_index in var.cdf_nifi_metric_monitor_val : [
      for nifi in team_index.nifi_monitor : [
        for metric in nifi.metrics : [
          for nifi_envs in var.regions_envs :
          {
            res_index = lower(replace("${team_index.team_name}_${replace(nifi.flowname, "-", "_")}_${metric.name}_${nifi_envs.location}_${nifi_envs.env}", " ", "_"))

            name    = title("${upper(nifi_envs.location)}_${upper(nifi_envs.env)}_CDF_${nifi.flowname}_${metric.name}")

            type    = "metric alert"
            
            message = "{{#is_alert}}\n\nThe \"${metric.name}\" metric for NiFi \"${nifi.flowname}\" in ${nifi_envs.location == "eu" && nifi.set_we_flag == true ? "we" : nifi_envs.location}_${nifi_envs.env == "stg" ? "stage" : nifi_envs.env} is above the defined threshold value.\n\n{{/is_alert}}\n\nNotify: ${nifi_envs.env == "dev" || nifi_envs.env == "qa" ? "" : "@opsgenie-Notifier"} ${nifi_envs.env == "qa" || nifi_envs.env == "stg" ? can("${nifi.notify_non_prod}") == true ? nifi.notify_non_prod : "" : "${nifi_envs.env == "prod"}" ? can("${nifi.notify_prod}") == true ? nifi.notify_prod : "" : ""}"
            # query = "max(last_5m):avg:nifi.${metric.name}{env:${nifi_envs.location == "eu" && nifi.set_we_flag == true ? "we" : nifi_envs.location}-${nifi_envs.env == "stg" ? "stage" : nifi_envs.env}, flow_name:${nifi_envs.location == "eu" && nifi.set_we_flag == true ? "we" : nifi_envs.location}-${nifi_envs.env}-${nifi.flowname}}"

            query = "max(last_5m):avg:nifi.${metric.name}{env:${nifi_envs.location == "eu" && nifi.set_we_flag == true ? "we" : nifi_envs.location}-${nifi_envs.env == "stg" ? "stage" : nifi_envs.env}, flow_name:${nifi_envs.location == "eu" && nifi.set_we_flag == true ? "we" : nifi_envs.location}-${nifi_envs.env == "prod" ? "prd" : nifi_envs.env}-${nifi.flowname}} > ${lookup(metric.threshold.critical,"${nifi_envs.env == "dev" || nifi_envs.env == "qa" ? nifi_envs.env : format("%s_%s", nifi_envs.location,nifi_envs.env)}")}"

            monitor_threshold = [
              {
                warning           = can("${metric.threshold.warning}") == true && metric.threshold.warning!= null ? "${metric.threshold.warning}" : null
                warning_recovery  = can("${metric.threshold.warning_recovery}") == true && metric.threshold.warning_recovery!= null ? "${metric.threshold.warning_recovery}" : null
                critical          = can("${lookup(metric.threshold.critical,"${nifi_envs.env == "dev" || nifi_envs.env == "qa" ? nifi_envs.env : format("%s_%s", nifi_envs.location,nifi_envs.env)}")}") == true ? "${lookup(metric.threshold.critical,"${nifi_envs.env == "dev" || nifi_envs.env == "qa" ? nifi_envs.env : format("%s_%s", nifi_envs.location,nifi_envs.env)}")}" : null
                critical_recovery = can("${metric.threshold.critical_recovery}") == true && metric.threshold.critical_recovery!= null ? "${metric.threshold.critical_recovery}" : null
              }
            ]

            priority = "${length(metric.mon_priority) > 0 ? lookup(metric.mon_priority, "${nifi_envs.env == "dev" || nifi_envs.env == "qa" ? nifi_envs.env : format("%s_%s", nifi_envs.location,nifi_envs.env)}") : lookup(var.monitors_priority, "${nifi_envs.env == "dev" || nifi_envs.env == "qa" ? nifi_envs.env : format("%s_%s", nifi_envs.location,nifi_envs.env)}")}"
            
            include_tags            = true
            notify_no_data          = false
            renotify_interval       = 180
            renotify_occurrences    = 2
            notify_audit            = false
            timeout_h               = 1

            create_metrics_monitors = contains(var.exclude_cdf_metric_monitor["${nifi_envs.location}_${nifi_envs.env}"], nifi.flowname)  == true ? "false" :  nifi_envs.create_monitor

            tags = concat(
              [
                for tag in var.default_tags : 
                tag if !can(regex("value_stream", tag)) # Filter out value_stream from default_tags
              ],
              [
                "pwc_territory:${nifi_envs.location}",
                "pwc_env:${nifi_envs.env}",
                lower("flow_identifier:${nifi.flowname}"),
                "metric:${metric.name}",
                "pwc_integration:splunk",
                "pwc_severity:${length(metric.mon_priority) > 0 ? lookup(metric.mon_priority, "${nifi_envs.env == "dev" || nifi_envs.env == "qa" || nifi_envs == "uat" ? nifi_envs.env : format("%s_%s", nifi_envs.location, nifi_envs.env)}") : lookup(var.monitors_priority, "${nifi_envs.env == "dev" || nifi_envs.env == "qa" || nifi_envs == "uat" ? nifi_envs.env : format("%s_%s", nifi_envs.location, nifi_envs.env)}")}",
                lower("team:${lookup(var.team_names, "${team_index.team_name}")}"),
                "pwc_ciid:${lookup(nifi.tag_ciid, nifi_envs.location)}",
                "value_stream:${lower(lookup(var.team_names, team_index.team_name)) == "captain_america" ? "gds" : "data_platform"}",
                
              ]
            )

          }
        ]
      ]
    ]
  ])
}

module "cdf_nifi_metric_monitor" {
  source           = "././module/dd-metrics-monitor"
  metrics_monitors = local.cdf_metric_monitor
}

output "cdf_nifi_metric_monitor_id" {
  value = module.cdf_nifi_metric_monitor.metrics_monitor_id
}


