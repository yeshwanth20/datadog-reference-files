
locals {
  # Building the list of all synthetic tests - all teams, all regions and all services
  synthetic_tests = flatten([
    for team_index in var.teams : [
      for service in team_index.services : [
        for synthetic in service.synthetic_test : [
          for reg in var.regions_envs :
          {
            name      = title("${service.name} Service")
            res_index = lower(replace("${service.name}_${reg.location}_${reg.env}_${synthetic.type}", " ", "_")) # Do not change. Used for loop indexing.
            locations = lookup(var.test_locations, reg.location)
            status    = "live"
            #app_url   = "${synthetic.type == "ssl" ? "" : "https://"}${service.synthetic_test_url_prefix}-${reg.location}-${reg.env}${reg.env == "stg" ? ".np" : ".lower"}${synthetic.url_suffix}"
            app_url       = "${reg.env}" == "prod" ? "${synthetic.type}" == "ssl" ? "${service.synthetic_test_url_prefix}-${reg.location}.${trimprefix("${synthetic.url_suffix}","-")}" : "https://${service.synthetic_test_url_prefix}-${reg.location}.${trimprefix("${synthetic.url_suffix}","-")}" : "${synthetic.type}" == "ssl" ? "${service.synthetic_test_url_prefix}-${reg.location}-${reg.env}${reg.env == "stg" ? ".np" : ".lower"}${synthetic.url_suffix}" : "https://${service.synthetic_test_url_prefix}-${reg.location}-${reg.env}${reg.env == "stg" ? ".np" : ".lower"}${synthetic.url_suffix}"
            message   = " {{#is_alert}} ${synthetic.type == "ssl" ? format("%s/%s","@workflow-Run-Certificate-Management-ADO-Pipeline(serviceName=\"${service.synthetic_test_url_prefix}\", environment=\"${upper(reg.location)}-${upper(reg.env == "stg" ? "stage" : reg.env)}\") ",var.synthetic_test_data_ssl.alert_message) : var.synthetic_test_data_health.alert_message} {{/is_alert}} \n Notify: ${reg.env == "dev" || reg.env == "qa" || reg.env == "uat" ? "" : "@opsgenie-Notifier"} ${reg.env == "qa" || reg.env == "stg" ? can("${service.notify_non_prod}") == true ? service.notify_non_prod : "" : "${reg.env == "prod"}" ? can("${service.notify_prod}") == true ? service.notify_prod : "" : ""}"
            test_data = synthetic.type == "ssl" ? var.synthetic_test_data_ssl : var.synthetic_test_data_health
            priority = "${synthetic.type == "health" ? length(service.synthetics_mon_priority) > 0 ? lookup(service.synthetics_mon_priority, "${reg.env == "dev" || reg.env == "qa" ? reg.env : format("%s_%s", reg.location,reg.env)}") : reg.env == "dev" || reg.env == "qa" ? "3" : "2" : length(service.synthetics_mon_priority) > 0 ? lookup(service.synthetics_mon_priority, "${reg.env == "dev" || reg.env == "qa" ? reg.env : format("%s_%s", reg.location,reg.env)}") : "3" }"
            tags      = concat(
              var.default_tags,
              [
                lower(replace(length(regexall("service", service.name)) > 0 ? "service:${service.name}" : "service:${service.name}-service", " ", "-")),
                "pwc_territory:${reg.location}",
                "pwc_env:${reg.env}",
                "pwc_type:${synthetic.type}",
                lower("team:${lookup(var.team_names,"${team_index.team_name}")}"),                
                "pwc_ciid:${lookup(service.tag_ciid, reg.location)}",
              ],
              reg.env == "prod" ? ["pwc_integration:splunk"] : synthetic.type == "ssl" ? ["pwc_integration:splunk"] : [],
              synthetic.type == "ssl" ? var.default_tags_synthetic_ssl : [],
            )
            # create_test = contains(var.exclude_teams_monitor["${reg.location}_${reg.env}"], service.name)  == true ? "false" : reg.create_test
            # create_test = contains(var.exclude_teams_monitor["${reg.location}_${reg.env}"], service.name)  == true ? "${length(regexall("^MFE$", service.name)) > 0 ? "true" : "false"}" : reg.create_test

            create_test = contains(var.exclude_teams_monitor["${reg.location}_${reg.env}"], service.name)  == true ? "${length(regexall("^MFE$", service.name)) > 0 ? true : "false"}" : reg.create_test
          }
        ]
      ]
    ]
  ])

  # Building the list of all SLO metric for synthetic tests
  slo_monitors = flatten([
    for team_index in var.teams : [
      for service in team_index.services : [
        for synthetic in service.synthetic_test : [
          for reg in var.regions_envs :
          {
            # create_slo  = contains(var.exclude_teams_monitor["${reg.location}_${reg.env}"], service.name)  == true ? "${length(regexall("^MFE$", service.name)) > 0 ? "true" : "false"}" : reg.create_slo

            create_slo  = contains(var.exclude_teams_monitor["${reg.location}_${reg.env}"], service.name)  == true ? "${length(regexall("^MFE$", service.name)) > 0 ? "${reg.location}" == "eu" && "${reg.env}" == "stg" ? "false" : true : "false"}" : reg.create_slo
            res_index   = lower(replace("${service.name}_${reg.location}_${reg.env}_${synthetic.type}", " ", "_")) # Used for loop indexing. Do not change & should match with res_index in synthetic_tests
            alert_name  = title("${service.name} Service - Availability SLO")
            type        = "monitor"
            description = title("${service.name} - Availability SLO")
            tags = concat(
              [
                for tag in var.default_tags : 
                tag if !can(regex("value_stream", tag)) # Filter out value_stream from default_tags
              ],
              [
                lower(replace(length(regexall("service", service.name)) > 0 ? "service:${service.name}" : "service:${service.name}-service", " ", "-")),
                "pwc_type:slo",
                "pwc_territory:${reg.location}",
                "pwc_env:${reg.env}",
                lower("team:${lookup(var.team_names, "${team_index.team_name}")}"),
                "pwc_ciid:${lookup(service.tag_ciid, reg.location)}",
                "value_stream:${lower(lookup(var.team_names, team_index.team_name)) == "captain_america" ? "gds" : "data_platform"}", # Conditional value_stream
                "gds:${lower(lookup(var.team_names, team_index.team_name)) == "captain_america" ? "true" : "false"}" # Conditional gds
              ],
              reg.env == "prod" ? ["pwc_integration:splunk"] : []
            )

          }
        ]
      ]
    ]
  ])

  # synthetic_oauth_login_tests = flatten([
  #   for team_index in var.teams : [
  #     for service in team_index.services : [
  #       for synthetic in service.synthetic_oauth_login_test : [
  #         for reg in var.regions_envs :
  #         {
  #           name          = title("${service.name} Service")
  #           res_index     = lower(replace("${service.name}_${reg.location}_${reg.env}_${synthetic.type}", " ", "_")) # Do not change. Used for loop indexing.
  #           locations     = lookup(var.test_locations, reg.location)
  #           status        = "live"
  #           app_url       = "${reg.env}" == "prod" ? "${synthetic.type}" == "ssl" ? "${service.synthetic_test_url_prefix}-${reg.location}.${trimprefix("${synthetic.url_suffix}","-")}" : "https://${service.synthetic_test_url_prefix}-${reg.location}.${trimprefix("${synthetic.url_suffix}","-")}" : "${synthetic.type}" == "ssl" ? "${service.synthetic_test_url_prefix}-${reg.location}-${reg.env}${reg.env == "stg" ? ".np" : ".lower"}${synthetic.url_suffix}" : "https://${service.synthetic_test_url_prefix}-${reg.location}-${reg.env}${reg.env == "stg" ? ".np" : ".lower"}${synthetic.url_suffix}" 
  #           message       = " {{#is_alert}} ${var.synthetic_test_data_health.alert_message} {{/is_alert}} \n Notify: ${service.pager_group} "
  #           test_data     = var.synthetic_test_data_health
  #           request_headers = "${synthetic.request_headers}"
  #           request_definition = "${synthetic.request_definition}"
  #           assertion = "${synthetic.assertion}"
  #           auth_username = synthetic.auth_username
  #           auth_password = synthetic.auth_password
  #           options_list = "${synthetic.options_list}"
  #           tags      = concat(
  #             var.default_tags,
  #             [
  #               lower(replace("service:${service.name}-service", " ", "-")),
  #               "pwc_territory:${reg.location}",
  #               "pwc_env:${reg.env}",
  #               "pwc_type:${synthetic.type}",
  #               lower("team:${lookup(var.team_names,"${team_index.team_name}")}"),
  #               "pwc_snow:${reg.tag_snow}",
  #               "pwc_ciid:${lookup(service.tag_ciid, reg.location)}",
  #             ]
  #           )
  #           create_test = contains(var.exclude_teams_monitor["${reg.location}_${reg.env}"], service.name)  == true ? "false" : reg.create_test
  #         }
  #       ]
  #     ]
  #   ]
  # ])
}


module "synthetic_test" {
  source              = "././module/synthetic-test"
  slo_monitors        = local.slo_monitors
  synthetic_tests     = local.synthetic_tests
  slo_thresholds      = var.slo_thresholds
  include_tags        = true
}

# module "synthetic_oauth_login_test" {
#   source              = "././module/synthetic-oauth-test"
#   synthetic_tests     = local.synthetic_oauth_login_tests
#   include_tags        = true
# }


# output "datadog_synthetic_test_test_id" {
#     value = module.synthetic_oauth_login_test.datadog_synthetic_test_id
# }

