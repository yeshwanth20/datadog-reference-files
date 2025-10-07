
locals {
  # Building the list of all synthetic tests - all teams, all regions and all services
  synthetic_tests_multiapi = flatten([
    for team_index in var.synthetics_multi_api_test_val : [
      for synthetics in team_index.synthetics : [
        for synthetics_monitor in synthetics.synthetics_monitor : [
          for api_test in synthetics_monitor.api_step : [
            for reg in api_test.regions_envs :
            {
              name         = title("${synthetics_monitor.name}")
              res_index    = lower(replace("${synthetics.service_name}_${synthetics_monitor.name}_${reg.location}_${reg.env}", " ", "_")) # Do not change. Used for loop indexing.
              locations    = lookup(var.multi_step_test_locations, reg.location)
              status       = "live" #changed the status to paused state to avoid alerts
              message      = "{{#is_alert}} ${synthetics_monitor.message}  {{/is_alert}} Notify: ${can("${synthetics_monitor.notify}") == false ? "@pagerduty-DD_DataPlatform_SRE" : " @pagerduty-DD_DataPlatform_SRE ${synthetics_monitor.notify}"}"
              test_data    = var.synthetic_test_data_multi_step
              api_step     = "${api_test.step}"
              env_location = "${reg.location}"
              env          = "${reg.env}"
              config_variable = can("${synthetics_monitor.config_variable}") == true ? "${synthetics_monitor.config_variable}" : null
              options_list_tick_interval = can("${synthetics_monitor.options_list_tick_interval}") == true ? "${synthetics_monitor.options_list_tick_interval}" : null
              options_list_min_location_failed = can("${synthetics_monitor.options_list_min_location_failed}") == true ? "${synthetics_monitor.options_list_min_location_failed}" : null
              options_list_min_failure_duration = can("${synthetics_monitor.options_list_min_failure_duration}") == true ? "${synthetics_monitor.options_list_min_failure_duration}" : null
              options_list_monitor_priority = can("${synthetics_monitor.options_list_monitor_priority}") == true ? "${synthetics_monitor.options_list_monitor_priority}" : null
              #synthetics_test_base_var = "${synthetics_monitor.synthetics_test_base_var}"
              synthetics_test_base_var = "${reg.env}" == "prod" ? "${synthetics.synthetic_test_url_prefix}-${reg.location}.${trimprefix("${api_test.url_suffix}", "-")}" : "${synthetics.synthetic_test_url_prefix}-${reg.location}-${reg.env}${reg.env == "stg" ? ".np" : ".lower"}${api_test.url_suffix}"
              synthetics_test_url_suffix = "${reg.env}" == "prod" ? "-${reg.location}.${trimprefix("${api_test.url_suffix}", "-")}" : "-${reg.location}-${reg.env}${reg.env == "stg" ? ".np" : ".lower"}${api_test.url_suffix}"
              tags = concat(
                var.default_tags,
                [
                  lower(replace("service:${synthetics.service_name}", " ", "-")),
                  "${"${reg.location}" == "we" ? "pwc_territory:eu" : "pwc_territory:${reg.location}"}",
                  "pwc_env:${reg.env}",
                  "pwc_type:Multistep_API",
                  lower("team:${lookup(var.team_names,"${team_index.team_name}")}"),
                  "pwc_ciid:${lookup(synthetics.tag_ciid, reg.location)}",
                ]
              )
              #create_test = reg.env == "prod" ? false : reg.create_test
              create_test = reg.create_test
            }
          ]
        ]
      ]
    ]
  ])
}
# Building the list of all SLO metric for synthetic tests

module "synthetic_test_multiapi" {
  source          = "././module/synthetic-multi-step-test"
  synthetic_tests = local.synthetic_tests_multiapi
  #include_tags        = true
}


