locals {
    synthetic_oauth_login_tests = flatten([
    for team_index in var.synthetics_test_login : [
      for service in team_index.services : [
        for synthetic in service.synthetic_oauth_login_test : [
          for reg in synthetic.regions_envs :
          {
            name          = title("${service.name} login")
            res_index     = lower(replace("${service.name}_${reg.location}_${reg.env}_${synthetic.type}", " ", "_")) # Do not change. Used for loop indexing.
            locations     = lookup(var.test_locations, reg.location)
            status        = "live"
            app_url       = "${reg.env}" == "prod" ? "${synthetic.type}" == "ssl" ? "${service.synthetic_test_url_prefix}-${reg.location}.${trimprefix("${synthetic.url_suffix}","-")}" : "https://${service.synthetic_test_url_prefix}-${reg.location}.${trimprefix("${synthetic.url_suffix}","-")}" : "${synthetic.type}" == "ssl" ? "${service.synthetic_test_url_prefix}-${reg.location}-${reg.env}${reg.env == "stg" ? ".np" : ".lower"}${synthetic.url_suffix}" : "https://${service.synthetic_test_url_prefix}-${reg.location}-${reg.env}${reg.env == "stg" ? ".np" : ".lower"}${synthetic.url_suffix}" 
            message       = " {{#is_alert}} ${var.synthetic_test_data_health.alert_message} {{/is_alert}} \n Notify: ${service.pager_group} "
            test_data     = var.synthetic_test_data_health
            request_headers = "${synthetic.request_headers}"
            request_definition = "${synthetic.request_definition}"
            assertion = "${synthetic.assertion}"
            auth_username = synthetic.auth_username
            auth_password = synthetic.auth_password
            config_variable = can("${synthetic.config_variable}") == true ? "${synthetic.config_variable}" : null
            options_list = "${synthetic.options_list}"
            tags      = concat(
              var.default_tags,
              [
                lower(replace("service:${service.name}-service", " ", "-")),
                "pwc_territory:${reg.location}",
                "pwc_env:${reg.env}",
                "pwc_type:${synthetic.type}",
                lower("team:${lookup(var.team_names,"${team_index.team_name}")}"),
                "pwc_ciid:${lookup(service.tag_ciid, reg.location)}",
              ]
            )
            create_test = reg.create_test
          }
        ]
      ]
    ]
  ])
}


module "synthetic_oauth_login_test" {
  source              = "././module/synthetic-oauth-test"
  synthetic_tests     = local.synthetic_oauth_login_tests
  include_tags        = true
}

output "datadog_synthetic_test_test_id" {
    value = module.synthetic_oauth_login_test.datadog_synthetic_test_id
}

