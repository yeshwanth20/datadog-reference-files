locals {  
  identifiers = ["subscription_name", "eh-name", "couchbase_env", "cosmosdb-name"]  
  
  paas_monitor = flatten([  
    for index in var.paas_monitors : [  
      for paas_service in index.paas : [  
        for identifier_key in local.identifiers : [  
          for identifier_value in try(paas_service[identifier_key], []) : [  
            for paas_monitor in paas_service.monitors : [  
              {  
                name    = title(paas_monitor.alert_name)  
                type    = "metric alert"  
                message = "{{#is_alert}} ${paas_monitor.message}  {{/is_alert}}\n Notify: @opsgenie-Notifier ${can("${paas_monitor.notify}") == true ? "${paas_monitor.notify}" : "" }"  
  
                query = replace(paas_monitor.query, "<${identifier_key}>", identifier_value)  
  
                monitor_threshold = [{  
                  warning           = can(paas_monitor.warning) == true ? paas_monitor.warning : null  
                  warning_recovery  = can(paas_monitor.warning_recovery) == true ? paas_monitor.warning_recovery : null  
                  critical          = can(paas_monitor.critical) == true ? paas_monitor.critical : null  
                  critical_recovery = can(paas_monitor.critical_recovery) == true ? paas_monitor.critical_recovery : null  
                }]  
  
                res_index               = lower(replace("${index.team_name}_${paas_service.service}_${paas_monitor.alert_name}_${identifier_value}", " ", "_"))  
                priority                = paas_monitor.priority  
                include_tags            = true  
                notify_no_data          = false  
                renotify_interval       = 180  
                renotify_occurrences    = 2  
                notify_audit            = false  
                timeout_h               = 1  
                create_metrics_monitors = paas_monitor.create_monitor  
  
                tags = concat(  
                  var.default_tags,  
                  [  
                    "${identifier_key}:${identifier_value}",  
                    lower("paas_service:${replace(paas_service.service, " ", "_")}"),
                    lower("team:${lookup(var.team_names, "${index.team_name}")}"),
                    "pwc_type:metric",  
                  ]  
                )  
              }  
            ]  
          ]  
        ]  
      ]  
    ]  
  ])  
}  
  
module "paas_monitor" {  
  source           = "./module/dd-metrics-monitor"  
  metrics_monitors = local.paas_monitor  
}  
  
output "paas_monitor_id" {  
  value = module.paas_monitor.metrics_monitor_id  
}  