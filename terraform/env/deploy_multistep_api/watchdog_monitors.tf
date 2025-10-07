locals {
  # Building the list of all Watchdog monitors
  watchdog_monitors = flatten(
    [
      for team_index in var.watchdog_monitors : [
        for monitor_detail in team_index.monitors : [
          {
            create_metrics_monitors = true

            res_index = lower(replace("${team_index.team_name}_${monitor_detail.name}", " ", "_"))

            name = "${monitor_detail.name}"

            type = "event-v2 alert"

            message = "{{#is_alert}}\n\n- This is a watchdog alert for services under ${lookup(var.team_names,"${team_index.team_name}")}.\n- This means there are some anomalies detected in application performance (APM), or logs.\n\n{{/is_alert}}\n\nNotify: ${monitor_detail.notify}\n"

            include_tags = true

            query = format(
              "events(\"source:watchdog (%s) env:(%s)\").rollup(\"count\").by(\"story_key,env\").last(\"30m\") > 0",
                join(
                  " OR ", flatten([
                    for category in monitor_detail.story_category : "(story_category:${category} (tags:(${join(" OR ",formatlist("\\\"%s%s\\\"", "service:", monitor_detail.services))})))"
                  ])
                ),
                join(" OR ", monitor_detail.envs)
            )

            monitor_threshold = [{
              critical          = "0"
              critical_recovery = null
              ok                = null
              unknown           = null
              warning           = null
              warning_recovery  = null
            }]

              notify_audit         = false
              notify_no_data       = false
              priority             = 3
              renotify_interval    = 180
              renotify_occurrences = 2
              timeout_h            = 1

              tags       = concat(
                var.default_tags,
                [
                  "pwc_type:watchdog",
                  lower("team:${lookup(var.team_names,"${team_index.team_name}")}")
                ],
              )
            
          }
        ]
      ]
    ]
  )
}

module "watchdog_monitors" {
  source             = "././module/dd-metrics-monitor"
  metrics_monitors   = local.watchdog_monitors
}

output "datadog_watchdog_monitor_id" {
  value = module.watchdog_monitors.metrics_monitor_id
}

