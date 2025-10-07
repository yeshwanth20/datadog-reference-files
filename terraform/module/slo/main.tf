
resource "datadog_service_level_objective" "slos" {
  for_each    = {
    for slo in var.slo_list : slo.res_index => slo
    if slo.create_slo == true
  }
  name        = each.value.alert_name
  type        = each.value.type
  description = each.value.description
  tags        = each.value.tags

  query {
    numerator   = each.value.numerator_query
    denominator = each.value.denominator_query
  }

  dynamic "thresholds" {
    for_each = var.slo_thresholds.slo_timeframes
    content {
      timeframe = thresholds.value
      target    = var.slo_thresholds.slo_target_warn
      warning   = var.slo_thresholds.slo_warning
    }
  }
}


