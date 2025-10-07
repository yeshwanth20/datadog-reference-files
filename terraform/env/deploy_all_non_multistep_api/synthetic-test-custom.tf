
locals {
  # Building the list of all synthetic tests - all teams, all regions and all services
  synthetic_tests_custom = flatten([
    for team_index in var.synthetics_monitors_custom_val : [
      for synthetics in team_index.synthetics : [
        for synthetics_monitor in synthetics.synthetics_monitor : [
          for reg in var.regions_envs :
          {
            name      = title("${synthetics_monitor.name}")
            res_index = lower(replace("${synthetics.service_name}_${synthetics_monitor.name}_${reg.location}_${reg.env}_${synthetics_monitor.type}_${synthetics_monitor.subtype}", " ", "_")) # Do not change. Used for loop indexing.
            locations = lookup(var.test_locations, reg.location)
            status    = "live"
            app_url   = lookup("${synthetics_monitor.synthetics_app_url}", "${"${reg.env}" == "dev" || "${reg.env}" == "qa" || "${reg.env}" == "uat"  ? "${reg.env}" : "${format("%s%s", "${reg.location}", "${reg.env}")}"}")
            message   = "{{#is_alert}} ${synthetics_monitor.type == "ssl" ? format("%s/%s","@workflow-Run-Certificate-Management-ADO-Pipeline(serviceName=\"${synthetics_monitor.synthetic_test_url_prefix}\", environment=\"${upper(reg.location)}-${upper(reg.env == "stg" ? "stage" : reg.env)}\")) ",synthetics_monitor.message) : synthetics_monitor.message} {{/is_alert}} Notify: ${can("${synthetics_monitor.notify}") == false ? " " : " ${synthetics_monitor.notify}"} ${reg.env == "dev" || reg.env == "qa" || reg.env == "uat" ? "" : "@opsgenie-Notifier"} ${reg.env == "qa" || reg.env == "stg" ? can("${synthetics_monitor.notify_non_prod}") == true ? synthetics_monitor.notify_non_prod : "" : "${reg.env == "prod"}" ? can("${synthetics_monitor.notify_prod}") == true ? synthetics_monitor.notify_prod : "" : ""}"
            test_data  = "${synthetics_monitor.sythetics_type}" == "ssl" ? var.synthetic_test_data_custom_ssl : var.synthetic_test_data_custom_health
            type       = "${synthetics_monitor.type}"
            subtype    = "${synthetics_monitor.subtype}"
            test_port  = "${synthetics_monitor.test_port}"
            assertions = "${synthetics_monitor.assertions}"
            tags = concat(
              var.default_tags,
              [
                lower(replace(length(regexall("service", synthetics.service_name)) > 0 ? "service:${synthetics.service_name}" : "service:${synthetics.service_name}-service", " ", "-")),
                "${"${reg.location}" == "eu" ? "pwc_territory:eu" : "pwc_territory:${reg.location}"}",
                "pwc_env:${reg.env}",
                "pwc_type:${synthetics_monitor.sythetics_type}",
                lower("team:${lookup(var.team_names,"${team_index.team_name}")}"),               
                "pwc_ciid:${lookup(synthetics.tag_ciid, reg.location)}",
              ],
              reg.env == "prod" ? [ "pwc_integration:splunk" ] : [],
              # synthetic.type == "ssl" ? var.default_tags_synthetic_ssl : [],
            )
            create_test = contains(var.exclude_synthetics_monitors_custom_val["${reg.location}_${reg.env}"], synthetics.service_name)  == true ? "false" : reg.create_test
          }
        ]
      ]
    ]
  ])
}
# Building the list of all SLO metric for synthetic tests

module "synthetic_test_custom" {
  source          = "././module/synthetic-test-custom"
  synthetic_tests = local.synthetic_tests_custom
  #include_tags        = true
}


