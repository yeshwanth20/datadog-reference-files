resource "datadog_synthetics_global_variable" "global_variable" {

  for_each = {
    for global_variable in var.global_variable : global_variable.res_index => global_variable
    if global_variable.create_test == true
  }
  name        = each.value.name
  value = each.value.value
  parse_test_id = each.value.parse_test_id
  dynamic "parse_test_options" {
    for_each = each.value.parse_test_options != null ? each.value.parse_test_options : []
    content {
        type = parse_test_options.value.type
        field = can(parse_test_options.value.field) == true ? parse_test_options.value.field : null
        dynamic parser {
          for_each = parse_test_options.value.parser != null ? parse_test_options.value.parser : []          
          content {
            type = can(parser.value.type) == true ? parser.value.type : null
            value = can(parser.value.value) == true ? parser.value.value : null
          }
      }
    }
  }
  
}

