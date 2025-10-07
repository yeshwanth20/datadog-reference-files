
locals {
  # Building the list of all Error Rate SLO's
  slo_error = flatten([
    for team_index in var.teams : [
      for service in team_index.services : [
        for reg in var.regions_envs : [
          {
            create_slo        = contains(var.exclude_slo_monitors["${reg.location}_${reg.env}"], service.name)  == true ? "false" : reg.create_slo
            res_index         = lower(replace("${service.name}_${reg.location}_${reg.env}_error", " ", "_")) # Used for loop indexing. Do not change & should match with res_index in synthetic_tests
            alert_name        = title("${service.name} - Error Rate SLO")
            type              = "metric"
            description       = title("${service.name} - Error Rate SLO")
            
            numerator_query   = format("%s-%s", format(
              "sum:trace.%s.request.hits{service:%s,env:%s}.as_count()", 
              "${service.trace }", 
              "${can("${service.service_name}") == true && "${service.service_name}" != null ? "${service.service_name}" : "${service.synthetic_test_url_prefix}"}", 
              contains(var.legacy_service_scope["${reg.location}_${reg.env}"], service.name)  == true ?
              "${reg.location == "eu" ? "${ service.set_we_tag == true ? "we" : "eu" }" : reg.location}-${reg.env == "stg" ? "stage" : reg.env}-reg.scope" :
                "${reg.location == "eu" ? "${ service.set_we_tag == true ? "we" : "eu" }" : reg.location}-${reg.env == "stg" ? "stage" : reg.env}-${reg.scope}"
            ),
            
            format(
              "sum:trace.%s.request.errors{service:%s,env:%s}.as_count()", 
              "${service.trace }", 
              "${can("${service.service_name}") == true && "${service.service_name}" != null ? "${service.service_name}" : "${service.synthetic_test_url_prefix}"}",
              contains(var.legacy_service_scope["${reg.location}_${reg.env}"], service.name)  == true ?
              "${reg.location == "eu" ? "${ service.set_we_tag == true ? "we" : "eu" }" : reg.location}-${reg.env == "stg" ? "stage" : reg.env}-reg.scope" :
              "${reg.location == "eu" ? "${ service.set_we_tag == true ? "we" : "eu" }" : reg.location}-${reg.env == "stg" ? "stage" : reg.env}-${reg.scope}"
            ))
            
            denominator_query = format(
              "sum:trace.%s.request.hits{service:%s,env:%s}.as_count()", 
              "${service.trace }", 
              "${can("${service.service_name}") == true && "${service.service_name}" != null ? "${service.service_name}" : "${service.synthetic_test_url_prefix}"}", contains(var.legacy_service_scope["${reg.location}_${reg.env}"], service.name)  == true ?
              "${reg.location == "eu" ? "${ service.set_we_tag == true ? "we" : "eu" }" : reg.location}-${reg.env == "stg" ? "stage" : reg.env}-reg.scope":
              "${reg.location == "eu" ? "${ service.set_we_tag == true ? "we" : "eu" }" : reg.location}-${reg.env == "stg" ? "stage" : reg.env}-${reg.scope}"
            )

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
                "pwc_slo_metric:error_rate",
                "value_stream:${lower(lookup(var.team_names, team_index.team_name)) == "captain_america" ? "gds" : "data_platform"}", # Conditional value_stream
                
              ]
            )}
          ]]]])

  slo_latency = flatten([
    for team_index in var.teams : [
      for service in team_index.services : [
        for reg in var.regions_envs : [
          {
            create_slo        = contains(var.exclude_slo_monitors["${reg.location}_${reg.env}"], service.name)  == true ? "false" : reg.create_slo
            res_index         = lower(replace("${service.name}_${reg.location}_${reg.env}_latency", " ", "_")) # Used for loop indexing. Do not change & should match with res_index in synthetic_tests
            alert_name        = title("${service.name} - Latency SLO")
            type              = "metric"
            description       = title("${service.name} - Latency SLO")
            
            numerator_query   = format(
              "count(v: v<=5):trace.%s.request{env:%s,service:%s}", 
              "${service.trace }",contains(var.legacy_service_scope["${reg.location}_${reg.env}"], service.name)  == true ?
              "${reg.location == "eu" ? "${ service.set_we_tag == true ? "we" : "eu" }" : reg.location}-${reg.env == "stg" ? "stage" : reg.env}-reg.scope": 
              "${reg.location == "eu" ? "${ service.set_we_tag == true ? "we" : "eu" }" : reg.location}-${reg.env == "stg" ? "stage" : reg.env}-${reg.scope}",
              "${can("${service.service_name}") == true && "${service.service_name}" != null ? "${service.service_name}" : "${service.synthetic_test_url_prefix}"}"
            )

            denominator_query = format(
              "count:trace.%s.request{env:%s,service:%s}",
              "${service.trace }",contains(var.legacy_service_scope["${reg.location}_${reg.env}"], service.name)  == true ?
              "${reg.location == "eu" ? "${ service.set_we_tag == true ? "we" : "eu" }" : reg.location}-${reg.env == "stg" ? "stage" : reg.env}-reg.scope": 
              "${reg.location == "eu" ? "${ service.set_we_tag == true ? "we" : "eu" }" : reg.location}-${reg.env == "stg" ? "stage" : reg.env}-${reg.scope}",
              "${can("${service.service_name}") == true && "${service.service_name}" != null ? "${service.service_name}" : "${service.synthetic_test_url_prefix}"}"
            )

            tags              = concat(
              var.default_tags,
              [
                lower(replace(length(regexall("service", service.name)) > 0 ? "service:${service.name}" : "service:${service.name}-service", " ", "-")),
                "pwc_type:slo",
                "pwc_territory:${reg.location}",
                "pwc_env:${reg.env}",
                lower("team:${lookup(var.team_names,"${team_index.team_name}")}"),                
                "pwc_ciid:${lookup(service.tag_ciid, reg.location)}",
                "pwc_slo_metric:latency"
              ]
            )}
        ]]]])

}

module "slo_latency" {
  source         = "././module/slo"
  slo_list       = local.slo_latency
  slo_thresholds = var.slo_thresholds
  include_tags   = true
}

module "slo_error" {
  source         = "././module/slo"
  slo_list       = local.slo_error
  slo_thresholds = var.slo_thresholds
  include_tags   = true
}


