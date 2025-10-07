locals {
  # Building the list of all Error Rate SLO's
  critical_error_monitors = flatten([
    for team_index in var.teams : [
      for service in team_index.services : [
        for alert in service.critical_alerts : [
          for reg in var.regions_envs : [
            for item in alert.high_error_rate : [
              {
                create_metrics_monitors = contains(var.exclude_teams_critical_monitor["${reg.location}_${reg.env}"], service.name)  == true ? "false" : reg.create_her_monitor

                res_index  = lower(replace("${service.name}_${reg.location}_${reg.env}_${replace(item, "/", "")}_error", " ", "_")) # Used for loop indexing. Do not change & should match with res_index in synthetic_tests
                name       = "${title(service.name)} - ${item} - High Error Rate"
                type       = "metric alert"
                message    = " **{{#is_alert}}**\n\n**Env: {{env.name}}** \n\n**Team: <Same as Team Tag>**\n\n**pwc_territory: {{pwc_territory.name}}**\n\n**Monitor Alert Message:**\n\n Error rate is too high \n\n**Possible Resolution Steps:**\n\n \n**{{/is_alert}}**\n\n**Notify: ${reg.env == "qa" || reg.env == "stg" ? can("${service.notify_non_prod}") == true ? service.notify_non_prod : "" : "${reg.env == "prod"}" ? can("${service.notify_prod}") == true ? service.notify_prod : "" : ""} ${can("${service.notify_her_monitors}") == true ? service.notify_her_monitors : ""}** "
                
                query      = replace(coalesce(alert.query, "${service.synthetic_test_url_prefix}" == "wbservices-api" ? "sum(last_5m):(sum:trace.flask.request.errors{env:${reg.location}-${"${reg.env}" == "stg" ? "stage" : "${reg.env}"}-${contains(var.legacy_services["${reg.location}_${reg.env}"], service.name) == true ? "green": reg.scope},service:${service.synthetic_test_url_prefix},resource_name:${item}}.as_count() / sum:trace.flask.request.hits{env:${reg.location}-${"${reg.env}" == "stg" ? "stage" : "${reg.env}"}-${contains(var.legacy_services["${reg.location}_${reg.env}"], service.name) == true ? "green": reg.scope},service:${service.synthetic_test_url_prefix},resource_name:${item}}.as_count()) > ${can("${lookup(alert.critical_threshold,"${reg.env == "dev" || reg.env == "qa" || reg.env == "uat" ? reg.env : format("%s_%s", reg.location,reg.env)}")}") == true ? "${lookup(alert.critical_threshold,"${reg.env == "dev" || reg.env == "qa" || reg.env == "uat" ? reg.env : format("%s_%s", reg.location,reg.env)}")}" : 0.05} " : "sum(last_5m):(sum:trace.servlet.request.errors{env:${reg.location}-${"${reg.env}" == "stg" ? "stage" : "${reg.env}"}-${contains(var.legacy_services["${reg.location}_${reg.env}"], service.name) == true ? "green": reg.scope},service:${service.synthetic_test_url_prefix},resource_name:${item}}.as_count() / sum:trace.servlet.request.hits{env:${reg.location}-${"${reg.env}" == "stg" ? "stage" : "${reg.env}"}-${contains(var.legacy_services["${reg.location}_${reg.env}"], service.name) == true ? "green": reg.scope},service:${service.synthetic_test_url_prefix},resource_name:${item}}.as_count()) > ${can("${lookup(alert.critical_threshold,"${reg.env == "dev" || reg.env == "qa" || reg.env == "uat" ? reg.env : format("%s_%s", reg.location,reg.env)}")}") == true ? "${lookup(alert.critical_threshold,"${reg.env == "dev" || reg.env == "qa" || reg.env == "uat" ? reg.env : format("%s_%s", reg.location,reg.env)}")}" : 0.05} "), "##ENV##",  "${reg.location == "eu" ? "${service.synthetic_test_url_prefix == "workbench-ng" || service.synthetic_test_url_prefix == "wb-mydata-api" || length(regexall("(?i)mfe", service.name)) > 0 ? "eu" : "eu"}" : reg.location}-${"${reg.env}" == "stg" ? "stage" : "${reg.env}"}-${contains(var.legacy_services["${reg.location}_${reg.env}"], service.name) == true ? "${service.synthetic_test_url_prefix == "workbench-ng" || service.synthetic_test_url_prefix == "wb-mydata-api" || length(regexall("(?i)mfe", service.name)) > 0 ? reg.scope : "green"}" : "${service.synthetic_test_url_prefix == "workbench-ng" || service.synthetic_test_url_prefix == "wb-mydata-api" || length(regexall("(?i)mfe", service.name)) > 0 ? reg.scope : "${service.synthetic_test_url_prefix == "workbench" || length(regexall("(?i)Workbench Node API", service.name)) > 0 ? "green" : "${service.synthetic_test_url_prefix == "django-engagement-admin" || length(regexall("(?i)django-engagement-admin", service.name)) > 0 ? "green" : reg.scope}"}"}"}")
                monitor_threshold    = [{
                  warning           = null
                  warning_recovery  = null
                  critical          = can("${lookup(alert.critical_threshold,"${reg.env == "dev" || reg.env == "qa" || reg.env == "uat" ? reg.env : format("%s_%s", reg.location,reg.env)}")}") == true ? "${lookup(alert.critical_threshold,"${reg.env == "dev" || reg.env == "qa" || reg.env == "uat" ? reg.env : format("%s_%s", reg.location,reg.env)}")}" : null
                  critical_recovery = can("${lookup(alert.critical_threshold, "${reg.env == "dev" || reg.env == "qa" || reg.env == "uat" ? reg.env : format("%s_%s", reg.location,reg.env)}")}") == true ? "${(format("%.2f", (0.8 * tonumber(lookup(alert.critical_threshold, "${reg.env == "dev" || reg.env == "qa" || reg.env == "uat" ? reg.env : format("%s_%s", reg.location,reg.env)}")))))}" : null
                  ok                = null
                }]

                include_tags         = true
                notify_audit         = false
                notify_no_data       = false
                #priority             = 3
                priority              = "${length(alert.mon_priority) > 0 ? lookup(alert.mon_priority, "${reg.env == "dev" || reg.env == "qa" || reg.env == "uat" ? reg.env : format("%s_%s", reg.location,reg.env)}") : lookup(var.monitors_priority, "${reg.env == "dev" || reg.env == "qa" || reg.env == "uat" ? reg.env : format("%s_%s", reg.location,reg.env)}")}"
                renotify_interval    = 180
                renotify_occurrences = 2
                timeout_h            = 1

                tags = concat(
                  [
                    for tag in var.default_tags : 
                    tag if !can(regex("value_stream", tag)) # Filter out value_stream from default_tags
                  ],
                  [
                    lower(replace(length(regexall("service", service.name)) > 0 ? "service:${service.name}" : "service:${service.name}-service", " ", "-")),
                    "pwc_type:metric",
                    "pwc_territory:${reg.location}",
                    "pwc_env:${reg.env}",
                    lower("team:${lookup(var.team_names, "${team_index.team_name}")}"),
                    "pwc_ciid:${lookup(service.tag_ciid, reg.location)}",
                    "value_stream:${lower(lookup(var.team_names, team_index.team_name)) == "captain_america" ? "gds" : "data_platform"}",  # Conditional value_stream
                  ],
                  reg.env == "prod" ? [ "pwc_integration:splunk" ] : []
                )

              }
            ]]]]]])

  critical_error_slo = flatten([
    for team_index in var.teams : [
      for service in team_index.services : [
        for alert in service.critical_alerts : [
          for reg in var.regions_envs : [
            #for item in alert.high_error_rate : [
              {
                create_slo = contains(var.exclude_teams_critical_monitor["${reg.location}_${reg.env}"], service.name)  == true || contains(var.critical_slo_custom["${reg.location}_${reg.env}"], service.name)  == true ? "false" : reg.create_slo
                
                #res_index  = lower(replace("${service.name}_${reg.location}_${reg.env}_${replace(item, "/", "")}_error", " ", "_")) # Used for loop indexing. Do not change & should match with res_index in synthetic_tests
                res_index  = lower(replace("${service.name}_${reg.location}_${reg.env}_error", " ", "_")) # Used for loop indexing. Do not change & should match with res_index in synthetic_tests
                alert_name = title("${service.name} Service - Critical API Error rate SLO")
                type       = "monitor"
                description = title("${service.name} - Critical API Error rate SLO")
                #monitor_res_index = [ lower(replace("${service.name}_${reg.location}_${reg.env}_${replace(item, "/", "")}_error", " ", "_")) ]
                monitor_ids = reg.env == "dev" || reg.env == "qa" || contains(var.exclude_teams_critical_monitor["${reg.location}_${reg.env}"], service.name)  == true || contains(var.critical_slo_custom["${reg.location}_${reg.env}"], service.name)  == true ? null :  [for key , value in alert.high_error_rate : module.critical_error_monitors.metrics_monitor_id[lower(replace("${service.name}_${reg.location}_${reg.env}_${replace("${value}", "/", "")}_error", " ", "_"))] ]
                #monitor_res_index = [ lower(replace("${service.name}_${reg.location}_${reg.env}_error", " ", "_")) ]
                # monitor_res_index = [
                #   for item in alert.high_error_rate:
                #   lower(replace("${service.name}_${reg.location}_${reg.env}_${replace(item, "/", "")}_error", " ", "_"))
                # ]
                tags = concat(
                  var.default_tags,
                  [
                    lower(replace(length(regexall("service", service.name)) > 0 ? "service:${service.name}" : "service:${service.name}-service", " ", "-")),
                    "pwc_type:slo",
                    "pwc_territory:${reg.location}",
                    "pwc_env:${reg.env}",
                    lower("team:${lookup(var.team_names,"${team_index.team_name}")}"),                    
                    "pwc_ciid:${lookup(service.tag_ciid, reg.location)}",
                  ],
                  reg.env == "prod" ? [ "pwc_integration:splunk" ] : [],
                )
              }
          ]]]]])
  critical_error_slo_custom = flatten([
    for team_index in var.teams_critical_slo_custom : [
      for service in team_index.services : [
        for alert in service.critical_alerts : [
          for reg in var.regions_envs : [
            #for item in alert.high_error_rate : [
              {
                create_slo = contains(var.critical_slo_custom["${reg.location}_${reg.env}"], service.name)  == true ?  reg.create_slo : "false"
                #res_index  = lower(replace("${service.name}_${reg.location}_${reg.env}_${replace(item, "/", "")}_error", " ", "_")) # Used for loop indexing. Do not change & should match with res_index in synthetic_tests
                res_index  = lower(replace("${service.name}_${reg.location}_${reg.env}_error", " ", "_")) # Used for loop indexing. Do not change & should match with res_index in synthetic_tests
                alert_name = title("${service.name} Service - Critical API Error rate SLO")
                type       = "monitor"
                description = title("${service.name} - Critical API Error rate SLO")
                #monitor_res_index = [ lower(replace("${service.name}_${reg.location}_${reg.env}_${replace(item, "/", "")}_error", " ", "_")) ]
                monitor_ids = contains(var.critical_slo_custom["${reg.location}_${reg.env}"], service.name)  == true ?  [for key , value in alert.high_error_rate : module.critical_error_monitors.metrics_monitor_id[lower(replace("${service.name}_${reg.location}_${reg.env}_${replace("${value}", "/", "")}_error", " ", "_"))] ] : null 
                #monitor_res_index = [ lower(replace("${service.name}_${reg.location}_${reg.env}_error", " ", "_")) ]
                # monitor_res_index = [
                #   for item in alert.high_error_rate:
                #   lower(replace("${service.name}_${reg.location}_${reg.env}_${replace(item, "/", "")}_error", " ", "_"))
                # ]
                tags = concat(
                  var.default_tags,
                  [
                    lower(replace(length(regexall("service", service.name)) > 0 ? "service:${service.name}" : "service:${service.name}-service", " ", "-")),
                    "pwc_type:slo",
                    "pwc_territory:${reg.location}",
                    "pwc_env:${reg.env}",
                    lower("team:${lookup(var.team_names,"${team_index.team_name}")}"),                    
                    "pwc_ciid:${lookup(service.tag_ciid, reg.location)}",
                  ],
                  reg.env == "prod" ? [ "pwc_integration:splunk" ] : [],
                )
              }
          ]]]]])  

}

module "critical_error_monitors" {
  source             = "././module/dd-metrics-monitor"
  metrics_monitors   = local.critical_error_monitors
  critical_error_slo = local.critical_error_slo
  slo_thresholds     = var.slo_thresholds
}

module "critical_error_monitor_slo_cutom"{
  source             = "././module/critical-slo-custom"
  #metrics_monitors   = local.critical_error_monitors
  critical_error_slo = local.critical_error_slo_custom
  slo_thresholds     = var.slo_thresholds
}

output "datadog_custom_monitor_id" {
    value = module.critical_error_monitors.metrics_monitor_id
}

