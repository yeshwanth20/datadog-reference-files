locals {
   global_variable = flatten([       
    for variable in var.global_variable : [
        for value in variable.value : [
            for reg in value.regions_envs : {
                res_index = lower(replace("${value.name}_${value.type}_${reg.location}_${reg.env}", " ", "_")) # Do not change. Used for loop indexing.
                name = "${value.type}" == "static" ? upper("${value.name}") : upper("DP_${value.name}_${reg.location}_${reg.env}")
                parse_test_id = "${value.type}" == "dynamic" ? module.synthetic_oauth_login_test.datadog_synthetic_test_id["${value.test_name}_${reg.location}_${reg.env}_login"] : null
                create_test = "${reg.create_test}"
                value = can("${value.value}") == true ? "${value.value}" : "${value.name}"
                parse_test_options = can("${value.parse_test_options}") == true ? "${value.parse_test_options}" : null
                tags = concat(
                    var.default_tags,
                    [
                        "pwc_env:${reg.env}",
                        "${"${reg.location}" == "we" ? "pwc_territory:eu" : "pwc_territory:${reg.location}"}",
                        "pwc_type:global_variable",
                        
                    ]
                )
            }  
        ]
    ]
   ])
}

module global_variable {
   source = "././module/global-variable"
   global_variable = local.global_variable
}

