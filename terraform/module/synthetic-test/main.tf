# Create a new Datadog Synthetics API/HTTP test
resource "datadog_synthetics_test" "synthetic_test" {
  for_each = {
    for test in var.synthetic_tests : test.res_index => test
    if test.create_test == true
  }
  name      = each.value.name
  message   = each.value.priority == 3 || each.value.priority == 4 ? replace(each.value.message, "@opsgenie-Notifier", "") : each.value.message
  type      = each.value.test_data.test_type
  subtype   = each.value.test_data.test_subtype
  locations = each.value.locations
  tags      = each.value.tags
  status    = each.value.status

  request_definition {
    method = each.value.test_data.test_subtype == "ssl" ? null : each.value.test_data.test_method
    url    = each.value.test_data.test_subtype == "ssl" ? null : each.value.app_url
    host   = each.value.test_data.test_subtype == "ssl" ? each.value.app_url : null
    port   = each.value.test_data.test_port
  }

  dynamic "assertion" {
    for_each = each.value.test_data.assertions
    content {
      type     = assertion.value.type
      operator = assertion.value.operator
      target   = assertion.value.target
    }
  }

  options_list {
    monitor_name       = each.value.name
    tick_every         = each.value.test_data.tick_interval
    follow_redirects   = each.value.test_data.follow_redirects
    accept_self_signed = each.value.test_data.accept_self_signed
    monitor_priority   = each.value.priority

    retry {
      count    = each.value.test_data.retry.count
      interval = each.value.test_data.retry.interval
    }
    monitor_options {
      renotify_interval = each.value.test_data.retry.renotify_interval
    } 
  } 
}

resource "datadog_service_level_objective" "slo_monitors" {
  for_each = {
    for slo in var.slo_monitors : slo.res_index => slo
    if slo.create_slo == true
  }
  name        = each.value.alert_name
  type        = each.value.type
  description = each.value.description
  tags        = each.value.tags
  monitor_ids = tolist([datadog_synthetics_test.synthetic_test[each.value.res_index].monitor_id])

  dynamic "thresholds" {
    for_each = var.slo_thresholds.slo_timeframes
    content {
      timeframe = thresholds.value
      target    = var.slo_thresholds.slo_target_warn
      warning   = var.slo_thresholds.slo_warning
    }
  }
}


