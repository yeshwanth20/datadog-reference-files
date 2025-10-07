resource "datadog_synthetics_test" "synthetic_test_custom" {
  for_each = {
    for test in var.synthetic_tests : test.res_index => test
    if test.create_test == true
  }
  name      = each.value.name
  message   = each.value.test_data.priority == 3 || each.value.test_data.priority == 4 ? replace(each.value.message, "@opsgenie-Notifier", "") : each.value.message
  type      = each.value.type
  subtype   = each.value.subtype
  locations = each.value.locations 
  tags      = each.value.tags
  status    = each.value.status

  
#   request_definition {
#     method = each.value.test_data.test_subtype == "tcp" ? null : each.value.test_data.test_method
#     url    = each.value.test_data.test_subtype == "tcp" ? null : each.value.app_url
#     host   = each.value.test_data.test_subtype == "tcp" ? each.value.app_url : null
#     port   = each.value.test_data.test_port
#   }
  request_definition {
    method = each.value.subtype == "tcp" || each.value.subtype == "ssl" ? null : each.value.test_data.test_method
    url    = each.value.subtype == "tcp" || each.value.subtype == "ssl" ? null : each.value.app_url
    host   = each.value.subtype == "tcp" || each.value.subtype == "ssl" ? each.value.app_url : null
    port   = each.value.subtype == "tcp" || each.value.subtype == "ssl" ? each.value.test_port : null
  }
  

  dynamic "assertion" {
    for_each = each.value.assertions
    content {
      type     = assertion.value.type
      operator = assertion.value.operator
      target   = assertion.value.target
      #property = assertion.value.property
    }
  }

  options_list {
    monitor_name       = each.value.name
    tick_every         = each.value.test_data.tick_interval
    follow_redirects   = each.value.test_data.follow_redirects
    accept_self_signed = each.value.test_data.accept_self_signed
    monitor_priority   = each.value.test_data.priority

    retry {
      count    = each.value.test_data.retry.count
      interval = each.value.test_data.retry.interval
    }
    monitor_options {
      renotify_interval = each.value.test_data.retry.renotify_interval
    } 
  } 
}

