# data "template_file" "work_bench_file_upload" {
#   template = "${file("data/Workbench_File_Upload")}"
# }

resource "datadog_synthetics_test" "synthetic_multistep_api_test" {
  for_each = {
    for test in var.synthetic_tests : test.res_index => test
    if test.create_test == true
  }
  name      = each.value.name
  message   = each.value.options_list_monitor_priority == 3 || each.value.options_list_monitor_priority == 4 ? replace(each.value.message, "@opsgenie-Notifier", "") :  each.value.message
  type      = each.value.test_data.type
  subtype   = each.value.test_data.subtype
  locations = each.value.locations
  tags      = each.value.tags
  status    = each.value.status
  dynamic "config_variable" {
    for_each =  each.value.config_variable != null ? each.value.config_variable : []
    content {
      type = config_variable.value.type == "custom" ? "global" : config_variable.value.type
      name = config_variable.value.type == "text" ? config_variable.value.name : config_variable.value.name == "wexp-bearer" ? "${lookup("${each.value.test_data.wexp-bearer_name}", "${"${each.value.env}" == "dev" || "${each.value.env}" == "qa" ? "${each.value.env}" : "${format("%s%s", "${each.value.env_location}", "${each.value.env}")}"}")}" : config_variable.value.name == "x-csrf-token" ?  "${lookup("${each.value.test_data.x-csrf-token_name}", "${"${each.value.env}" == "dev" || "${each.value.env}" == "qa" ? "${each.value.env}" : "${format("%s%s", "${each.value.env_location}", "${each.value.env}")}"}")}" : config_variable.value.name == "Authorization" ? "${lookup("${each.value.test_data.Authorization_name}", "${"${each.value.env}" == "dev" || "${each.value.env}" == "qa" ? "${each.value.env}" : "${format("%s%s", "${each.value.env_location}", "${each.value.env}")}"}")}" : config_variable.value.name == "referer" ? "${lookup("${each.value.test_data.referer_name}", "${"${each.value.env}" == "dev" || "${each.value.env}" == "qa" ? "${each.value.env}" : "${format("%s%s", "${each.value.env_location}", "${each.value.env}")}"}")}" : config_variable.value.type == "custom" ? config_variable.value.name : null
      
      pattern = can(config_variable.value.pattern) == true ? config_variable.value.pattern : null
      
      id =  config_variable.value.name == "wexp-bearer" ? "${lookup("${each.value.test_data.wexp-bearer_id}", "${"${each.value.env}" == "dev" || "${each.value.env}" == "qa" ? "${each.value.env}" : "${format("%s%s", "${each.value.env_location}", "${each.value.env}")}"}")}" : config_variable.value.name == "x-csrf-token" ?  "${lookup("${each.value.test_data.x-csrf-token_id}", "${"${each.value.env}" == "dev" || "${each.value.env}" == "qa" ? "${each.value.env}" : "${format("%s%s", "${each.value.env_location}", "${each.value.env}")}"}")}" : config_variable.value.name == "Authorization" ? "${lookup("${each.value.test_data.Authorization_id}", "${"${each.value.env}" == "dev" || "${each.value.env}" == "qa" ? "${each.value.env}" : "${format("%s%s", "${each.value.env_location}", "${each.value.env}")}"}")}" : config_variable.value.name == "referer" ? "${lookup("${each.value.test_data.referer_id}", "${"${each.value.env}" == "dev" || "${each.value.env}" == "qa" ? "${each.value.env}" : "${format("%s%s", "${each.value.env_location}", "${each.value.env}")}"}")}" : config_variable.value.type == "custom" ? config_variable.value.id : null
    }
    
  }

  dynamic "api_step" {
    for_each = each.value.api_step
    content {
      name          = api_step.value.name
      subtype       = api_step.value.subtype
      allow_failure = can(api_step.value.allow_failure) == true ? api_step.value.allow_failure : false
      is_critical   = can(api_step.value.is_critical) == true ? api_step.value.allow_failure == true ? can(api_step.value.is_critical) == true ? api_step.value.is_critical : false : false : false
      value = api_step.value.subtype == "wait" && can(api_step.value.value) ? api_step.value.value : null

      dynamic "assertion" {
        for_each = [
          for assertion in api_step.value.assertion : assertion
          if contains(keys(api_step.value), "assertion") && api_step.value.assertion != null
        ]
        content {
          type     = can(assertion.value.type) == true ? assertion.value.type : null
          operator = can(assertion.value.operator) == true ? assertion.value.operator : null
          target   = can(assertion.value.target) == true ? assertion.value.target : null
          property = can(assertion.value.property) == true ? assertion.value.property : null
          dynamic "targetjsonpath" {
            for_each = assertion.value.targetjsonpath != null ? assertion.value.targetjsonpath : []
            content {
              operator    = targetjsonpath.value.operator
              jsonpath    = targetjsonpath.value.jsonpath
              targetvalue = targetjsonpath.value.targetvalue
            }
          }
        }
      }

      request_query = can(api_step.value.request_query) == true ? api_step.value.request_query : null

      dynamic "request_definition" {
        for_each = api_step.value.subtype == "http" ? [1] : []
        content {
          method = can(api_step.value.request_definition.method) == true ? api_step.value.request_definition.method : null
          
          url = can("${api_step.value.request_definition.url}") == true ? "${api_step.value.request_definition.url}" : can("${api_step.value.request_definition.synthetic_test_url_prefix}") == true ? "${api_step.value.request_definition.url_suffix}" != null ? "${format("https://%s%s%s", "${api_step.value.request_definition.synthetic_test_url_prefix}","${each.value.synthetics_test_url_suffix}","${api_step.value.request_definition.url_suffix}")}" : "${format("https://%s%s%s", "${api_step.value.request_definition.synthetic_test_url_prefix}","${each.value.synthetics_test_url_suffix}","${join(",", matchkeys(api_step.value.request_definition.url_suffix_value, api_step.value.request_definition.url_suffix_key, ["${each.value.env}" == "dev" || "${each.value.env}" == "qa" ? "${each.value.env}" : "${format("%s%s", "${each.value.env_location}", "${each.value.env}")}"]))}")}" : "${api_step.value.request_definition.url_suffix}" != null ? "${format("https://%s%s", "${each.value.synthetics_test_base_var}", "${api_step.value.request_definition.url_suffix}")}" : "${format("https://%s%s", "${each.value.synthetics_test_base_var}", "${join(",", matchkeys(api_step.value.request_definition.url_suffix_value, api_step.value.request_definition.url_suffix_key, ["${each.value.env}" == "dev" || "${each.value.env}" == "qa" ? "${each.value.env}" : "${format("%s%s", "${each.value.env_location}", "${each.value.env}")}"]))}")}"
          
          body = api_step.value.request_definition.body == "multi_file_path" ? file("${join(",", matchkeys(api_step.value.request_definition.body_file_path_value, api_step.value.request_definition.body_file_path_key, ["${each.value.env}" == "dev" || "${each.value.env}" == "qa" ? "${each.value.env}" : "${format("%s%s", "${each.value.env_location}", "${each.value.env}")}"]))}") : api_step.value.request_definition.body == "file_path" ? file("${api_step.value.request_definition.body_file_path}") : can(api_step.value.request_definition.body) == true ? api_step.value.request_definition.body : null
          body_type = "application/json"
          no_saving_response_body = api_step.value.request_definition.no_saving_response_body
          allow_insecure          = can(api_step.value.request_definition.allow_insecure) == true ? api_step.value.request_definition.allow_insecure : false
        }
      }
      request_headers = api_step.value.subtype == "http" ? {
        wexp-bearer               = "${api_step.value.request_headers.wexp-bearer}" != null ? "${lookup("${each.value.test_data.wexp-bearer}", "${"${each.value.env}" == "dev" || "${each.value.env}" == "qa" ? "${each.value.env}" : "${format("%s%s", "${each.value.env_location}", "${each.value.env}")}"}")}" : null
        connection                = can(api_step.value.request_headers.connection) == true ? api_step.value.request_headers.connection : null
        content-type              = can(api_step.value.request_headers.content-type) == true ? api_step.value.request_headers.content-type : null
        accept-encoding           = can(api_step.value.request_headers.accept-encoding) == true ? api_step.value.request_headers.accept-encoding : null
        x-csrf-token              = "${api_step.value.request_headers.x-csrf-token}" != null ? "${lookup("${each.value.test_data.x-csrf-token}", "${"${each.value.env}" == "dev" || "${each.value.env}" == "qa" ? "${each.value.env}" : "${format("%s%s", "${each.value.env_location}", "${each.value.env}")}"}")}" : null
        Authorization             = "${api_step.value.request_headers.Authorization}" != null ? "${lookup("${each.value.test_data.Authorization}", "${"${each.value.env}" == "dev" || "${each.value.env}" == "qa" ? "${each.value.env}" : "${format("%s%s", "${each.value.env_location}", "${each.value.env}")}"}")}" : null
        x-ms-encryption-algorithm = can(api_step.value.request_headers.x-ms-encryption-algorithm) == true ? api_step.value.request_headers.x-ms-encryption-algorithm : null
        x-ms-client-request-id    = can(api_step.value.request_headers.x-ms-client-request-id) == true ? api_step.value.request_headers.x-ms-client-request-id : null
        x-ms-blob-type            = can(api_step.value.request_headers.x-ms-blob-type) == true ? api_step.value.request_headers.x-ms-blob-type : null
        x-ms-meta-guid            = can(api_step.value.request_headers.x-ms-meta-guid) == true ? api_step.value.request_headers.x-ms-meta-guid : null
        accept                    = can(api_step.value.request_headers.accept) == true ? api_step.value.request_headers.accept : null
        referer                   = can(api_step.value.request_headers.referer) ? lookup(each.value.test_data.referer, each.value.env == "dev" || each.value.env == "qa" ? each.value.env : format("%s%s", each.value.env_location, each.value.env)) : null        
        user-agent                = can(api_step.value.request_headers.user-agent) == true ? api_step.value.request_headers.user-agent : null
      } : {}

      dynamic "extracted_value" {
        for_each = contains(keys(api_step.value), "extracted_value")  ? api_step.value.extracted_value : []
        content {
          name = extracted_value.value.name
          type = extracted_value.value.type
          parser {
            type  = extracted_value.value.parser.type
            value = extracted_value.value.parser.value
          }
        }

      }
      dynamic "retry" {
        for_each = can(api_step.value.retry) == true ? api_step.value.retry : []
        content {
          count    = retry.value.count
          interval = retry.value.interval
        }
      }
    }
  }
  options_list {
    tick_every         = each.value.options_list_tick_interval != null ? each.value.options_list_tick_interval : each.value.test_data.tick_interval
    accept_self_signed = each.value.test_data.accept_self_signed
    min_location_failed = each.value.options_list_min_location_failed != null ? each.value.options_list_min_location_failed : 1
    min_failure_duration = each.value.options_list_min_failure_duration !=null ? each.value.options_list_min_failure_duration : 0
    monitor_name  = each.value.name
    monitor_priority   = each.value.options_list_monitor_priority
    retry {
      count    = 2
      interval = 5000
    }
  }

}


