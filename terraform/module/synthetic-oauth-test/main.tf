# Create a new Datadog Synthetics API/HTTP test
resource "datadog_synthetics_test" "synthetic_test_oauth" {
  for_each = {
    for test in var.synthetic_tests : test.res_index => test
    if test.create_test == true
  }
  name      = each.value.name
  message   = each.value.message
  type      = each.value.test_data.test_type
  subtype   = each.value.test_data.test_subtype
  locations = each.value.locations
  tags      = each.value.tags
  status    = each.value.status
  
   dynamic "config_variable" {
    for_each =  each.value.config_variable != null ? each.value.config_variable : []
    content {
      type = config_variable.value.type == "custom" ? "global" : config_variable.value.type
      name = config_variable.value.type == "text" ? config_variable.value.name : config_variable.value.name == "wexp-bearer" ? "${lookup("${each.value.test_data.wexp-bearer_name}", "${"${each.value.env}" == "dev" || "${each.value.env}" == "qa" ? "${each.value.env}" : "${format("%s%s", "${each.value.env_location}", "${each.value.env}")}"}")}" : config_variable.value.name == "x-csrf-token" ?  "${lookup("${each.value.test_data.x-csrf-token_name}", "${"${each.value.env}" == "dev" || "${each.value.env}" == "qa" ? "${each.value.env}" : "${format("%s%s", "${each.value.env_location}", "${each.value.env}")}"}")}" : config_variable.value.name == "Authorization" ? "${lookup("${each.value.test_data.Authorization_name}", "${"${each.value.env}" == "dev" || "${each.value.env}" == "qa" ? "${each.value.env}" : "${format("%s%s", "${each.value.env_location}", "${each.value.env}")}"}")}" : config_variable.value.name == "referer" ? "${lookup("${each.value.test_data.referer_name}", "${"${each.value.env}" == "dev" || "${each.value.env}" == "qa" ? "${each.value.env}" : "${format("%s%s", "${each.value.env_location}", "${each.value.env}")}"}")}" : config_variable.value.type == "custom" ? config_variable.value.name : null
      
      pattern = can(config_variable.value.pattern) == true ? config_variable.value.pattern : null
      
      id =  config_variable.value.name == "wexp-bearer" ? "${lookup("${each.value.test_data.wexp-bearer_id}", "${"${each.value.env}" == "dev" || "${each.value.env}" == "qa" ? "${each.value.env}" : "${format("%s%s", "${each.value.env_location}", "${each.value.env}")}"}")}" : config_variable.value.name == "x-csrf-token" ?  "${lookup("${each.value.test_data.x-csrf-token_id}", "${"${each.value.env}" == "dev" || "${each.value.env}" == "qa" ? "${each.value.env}" : "${format("%s%s", "${each.value.env_location}", "${each.value.env}")}"}")}" : config_variable.value.name == "Authorization" ? "${lookup("${each.value.test_data.Authorization_id}", "${"${each.value.env}" == "dev" || "${each.value.env}" == "qa" ? "${each.value.env}" : "${format("%s%s", "${each.value.env_location}", "${each.value.env}")}"}")}" : config_variable.value.name == "referer" ?  "${lookup("${each.value.test_data.referer_id}", "${"${each.value.env}" == "dev" || "${each.value.env}" == "qa" ? "${each.value.env}" : "${format("%s%s", "${each.value.env_location}", "${each.value.env}")}"}")}" : config_variable.value.type == "custom" ? config_variable.value.id : null
    }
    
  }
  
  request_definition {
    method = can(each.value.request_definition["method"]) == true ? each.value.request_definition["method"] : null
    url = each.value.app_url
    body = can(each.value.request_definition["body"]) == true ? each.value.request_definition["body"] : null
    no_saving_response_body = can(each.value.request_definition["no_saving_response_body"]) == true ? each.value.request_definition["no_saving_response_body"] : false
    port = can(each.value.request_definition["port"]) == true ? each.value.request_definition["port"] : 443
  }
  request_headers = can(each.value.request_headers) == true ? each.value.request_headers : null
  request_basicauth {
    username = each.value.auth_username
    password = each.value.auth_password
  }
  dynamic "assertion" {
  for_each = each.value.assertion
    content {
      type     = can(assertion.value.type) == true ? assertion.value.type : null
      operator = can(assertion.value.operator) == true ? assertion.value.operator : null
      target   = can(assertion.value.target) == true ? assertion.value.target : null
      property = can(assertion.value.property) == true ? assertion.value.property : null
      dynamic "targetjsonpath" {
        for_each = assertion.value.targetjsonpath != null ? assertion.value.targetjsonpath : []
        content {
          operator = targetjsonpath.value.operator
          jsonpath = targetjsonpath.value.jsonpath
          targetvalue = targetjsonpath.value.targetvalue
        }
      }            
    }          
  }
  
  options_list {
    monitor_name       = each.value.name
    tick_every         = can(each.value.options_list["tick_every"]) == true ? each.value.options_list["tick_every"] : 300
    follow_redirects   = can(each.value.options_list["follow_redirects"]) == true ? each.value.options_list["follow_redirects"] : true
    accept_self_signed = can(each.value.options_list["accept_self_signed"]) == true ? each.value.options_list["accept_self_signed"] : true

    retry {
      count    = can(each.value.options_list["retry_count"]) == true ? each.value.options_list["retry_count"] : 3
      interval = can(each.value.options_list["retry_interval"]) == true ? each.value.options_list["retry_interval"] : 300
    }
    monitor_options {
      renotify_interval = can(each.value.options_list["renotify_interval"]) == true ? each.value.options_list["renotify_interval"] : 180
    } 
  } 
}



