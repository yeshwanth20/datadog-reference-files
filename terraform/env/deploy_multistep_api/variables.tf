variable "default_tags" {
  default = [
    "value_stream:data_platform",
    "managed_by:terraform",
  ]
}

variable "default_tags_synthetic_ssl" {
  default = [
    "pwc_integration:splunk",
    "pwc_severity:3",
    "pwc_target_persona:business,product_owner",
  ]
}

variable "team_names" {
  default = {
    TEAM_NAME_1 = "Orca",
    TEAM_NAME_2 = "Blue_Whales",
    TEAM_NAME_3 = "Sea_Lions",
    TEAM_NAME_4 = "Dolphins",
    TEAM_NAME_6 = "Captain_America",
    TEAM_NAME_7 = "devops",
  }
}

variable "slo_thresholds" {
  type = object({
    slo_timeframes  = list(string)
    slo_target_warn = string
    slo_warning     = string
  })
  description = "Define threshold timeframes"
  default = {
    slo_timeframes  = ["7d", "30d", "90d"]
    slo_target_warn = "98"
    slo_warning     = "99"
  }
}

variable "synthetic_test_data_health" {
  default = {
    alert_message      = "Endpoint has been unresponsive for more than 5m."
    follow_redirects   = true   # For API HTTP test, whether or not the test should follow redirects.
    accept_self_signed = true   # For SSL test, whether or not the test should allow self signed certificates.
    test_type          = "api"  # Type of synthetic test
    test_subtype       = "http" # Subtype of synthetic test
    test_method        = "GET"  # Calling Method type of synthetic test
    tick_interval      = 300    # Ping time interval
    test_port          = 443
    retry = {
      count             = 3
      interval          = 60000
      renotify_interval = 180
    }
    assertions = [
      {
        type     = "statusCode"
        operator = "is"
        target   = 200
      },
      {
        type     = "responseTime"
        operator = "lessThan"
        target   = 5000
      }
    ]
  }
}

variable "synthetic_test_data_custom_health" {
  default = {
    alert_message      = "Endpoint has been unresponsive for more than 5m."
    follow_redirects   = true  # For API HTTP test, whether or not the test should follow redirects.
    accept_self_signed = true  # For SSL test, whether or not the test should allow self signed certificates.
    test_method        = "GET" # Calling Method type of synthetic test
    tick_interval      = 300   # Ping time interval
    retry = {
      count             = 3
      interval          = 60000
      renotify_interval = 180
    }
  }
}

variable "synthetic_test_data_ssl" {
  default = {
    alert_message      = "{{host.name}}  has a certificate expiration date within 2 months."
    follow_redirects   = true  # For API HTTP test, whether or not the test should follow redirects.
    accept_self_signed = true  # For SSL test, whether or not the test should allow self signed certificates.
    test_type          = "api" # Type of synthetic test
    test_subtype       = "ssl" # Subtype of synthetic test
    test_method        = "GET" # Calling Method type of synthetic test
    tick_interval      = 43200 # Ping time interval
    test_port          = 443
    retry = {
      count             = 2
      interval          = 5000
      renotify_interval = null
    }
    assertions = [
      {
        type     = "certificate"
        operator = "isInMoreThan"
        target   = 60
      },
      {
        type     = "responseTime"
        operator = "lessThan"
        target   = 5000
      }
    ]
  }
}

variable "synthetic_test_data_custom_ssl" {
  default = {
    alert_message      = "{{host.name}}  has a certificate expiration date within 2 months."
    follow_redirects   = true  # For API HTTP test, whether or not the test should follow redirects.
    accept_self_signed = true  # For SSL test, whether or not the test should allow self signed certificates.
    test_method        = "GET" # Calling Method type of synthetic test
    tick_interval      = 43200 # Ping time interval
    retry = {
      count             = 2
      interval          = 5000
      renotify_interval = 180
    }
  }
}

variable "test_locations" {
  default = {
    us = ["pl:pwc-az-us-innovation-assurance-01-b2c26fb05c19e8cd21a92706c19826f0"]
    eu = ["pl:pwc-az-we-labs20prd-api_url-01-6c2b5e71f9f4d5941118d4e94e6e6ca8"]
    au = ["pl:pwc-az-au-labs20prd-api_url-01-0b674d675c6fa7787654556391a268ac"]
    sg = ["pl:pwc-az-se-labs20prd-api_url-01-952574110b820872b723e1d8bf09bbcb"]
  }
}

variable "multi_step_test_locations" {
  default = {
    us = ["pl:pwc-az-us-innovation-assurance-01-b2c26fb05c19e8cd21a92706c19826f0"]
    eu = ["pl:pwc-az-we-labs20prd-api_url-01-6c2b5e71f9f4d5941118d4e94e6e6ca8"]
    au = ["pl:pwc-az-au-labs20prd-api_url-01-0b674d675c6fa7787654556391a268ac"]
    sg = ["pl:pwc-az-se-labs20prd-api_url-01-952574110b820872b723e1d8bf09bbcb"]
  }
}

variable "legacy_apps" {
  default = [
    "aci-service",
    "catalogue-service-v2",
    "chapi-api",
    "django-engagement-admin", "django-engagement-admin-Lite", "django-notification",
    "dns-service",
    "dp-event-hub-logs",
    "dremio-service",
    "engagement-service-v2",
    "kube-utility-service",
    "kv-store",
    "ldap-admin-service",
    "memsql-admin",
    "service-provisioning-api",
    "vizinsights-migration",
    "wbservices-api",
    "workbench-node-api",
    "workbench-node-api-redis",
    "workbench-react-ui",
    "workbench-skylight"
  ]
}

###############################################################################

# multi step synthetics monitor

variable "synthetic_test_data_multi_step" {
  default = {
    accept_self_signed = true  # For SSL test, whether or not the test should allow self signed certificates.
    tick_interval      = 43200 # Ping time interval
    type               = "api"
    subtype            = "multi"
    wexp-bearer = {
      # dev    = "{{ DP_WEXP_BEARER_US_DEV }}"
      # qa     = "{{ DP_WEXP_BEARER_US_QA }}"
      usstg  = "{{ DP_WEXP_BEARER_US_STG }}"
      eustg  = "{{ DP_WEXP_BEARER_EU_STG }}"
      euprod = "{{ DP_WEXP_BEARER_EU_PROD }}"
      usprod = "{{ DP_WEXP_BEARER_US_PROD }}"
      auprod = "{{ DP_WEXP_BEARER_AU_PROD }}"
    }
    x-csrf-token = {
      # dev    = "{{ DP_X_CSRF_TOKEN_US_DEV }}"
      # qa     = "{{ DP_X_CSRF_TOKEN_US_QA }}"
      usstg  = "{{ DP_X_CSRF_TOKEN_US_STG }}"
      eustg  = "{{ DP_X_CSRF_TOKEN_EU_STG }}"
      euprod = "{{ DP_X_CSRF_TOKEN_EU_PROD }}"
      usprod = "{{ DP_X_CSRF_TOKEN_US_PROD }}"
      auprod = "{{ DP_X_CSRF_TOKEN_AU_PROD }}"
    }
    Authorization = {
      # dev    = "{{ DP_BEARER_US_DEV }}"
      # qa     = "{{ DP_BEARER_US_QA }}"
      usstg  = "{{ DP_BEARER_US_STG }}"
      eustg  = "{{ DP_BEARER_EU_STG }}"
      euprod = "{{ DP_BEARER_EU_PROD }}"
      usprod = "{{ DP_BEARER_US_PROD }}"
      auprod = "{{ DP_BEARER_AU_PROD }}"
      sgprod = "{{ DP_BEARER_SG_PROD }}"
    }
    referer = {
      euprod = "{{ REFERER_EU_PROD }}"
      usprod = "{{ REFERER_US_PROD }}"
      auprod = "{{ REFERER_AU_PROD }}"
      sgprod = "{{ REFERER_SG_PROD }}"
    }    
    wexp-bearer_id = {
      # dev    = "445ed2c7-83e7-495a-83a1-b8d7b75c7c91"
      # qa     = "b9095016-c336-4285-9bc0-c93ee339c059"
      usstg  = "4e0fc292-c83e-4697-b21d-b2a254315c8a"
      eustg  = "daf72e53-7554-4b1e-a6c1-d56c772cae72"
      euprod = "9dffd97e-6a61-4b2c-9bcf-45d01e79c0e9"
      usprod = "e1169275-236d-4f66-bd51-d0f092feb5a5"
      auprod = "fdd8133e-1087-4353-b2a2-bd403e29f351"
    }
    x-csrf-token_id = {
      # dev    = "392fe569-d6a3-47d8-928c-e44ecfdfcf2b"
      # qa     = "2b4554d0-cdf1-49cd-8023-a69dcc8e8613"
      usstg  = "6cb0c0a4-b44e-4727-a27b-df013c954ff4"
      eustg  = "dde1f480-c646-4ddf-adde-b5375d51669d"
      euprod = "a73cc486-124c-43d0-99e3-b0df07fbc869"
      usprod = "d824325c-f9ec-46d2-baf6-f905529d0e2f"
      auprod = "92369d62-fc06-40f1-b80e-cc97e210c7d4"
    }
    Authorization_id = {
      # dev    = "03f8494a-f022-41b9-a9fb-643b8688144d"
      # qa     = "d3f96b89-cb07-479c-b37c-8f08afd02019"
      usstg  = "59ed63cb-621f-4de6-b9e7-0c7be4db557e"
      eustg  = "00b78cd8-5dee-4a70-85dd-a05214a5a10a"
      euprod = "31d70c00-537b-4380-b433-c2b9a64d5f90"
      usprod = "761dc953-9bf9-4364-9a93-8158e8fcd0ed"
      auprod = "2a232b28-ae73-4852-88ee-d35bf906cc26"
      sgprod = "f1de3fd0-3549-4702-9cae-4e4aa2ea2929"
    }
    referer_id = {
      euprod = "0bf5e8f8-9091-46b9-a833-ce20db745229"
      usprod = "6f084dbd-7e58-41f3-ba5e-de8ad5d5f8d1"
      auprod = "39e27241-43a1-42eb-8bbb-9a74e1120427"
      sgprod = "dd20111e-b696-401f-bf9f-c70b14d0e91d"
    }    
    wexp-bearer_name = {
      # dev    = "DP_WEXP_BEARER_US_DEV"
      # qa     = "DP_WEXP_BEARER_US_QA"
      usstg  = "DP_WEXP_BEARER_US_STG"
      eustg  = "DP_WEXP_BEARER_EU_STG"
      euprod = "DP_WEXP_BEARER_EU_PROD"
      usprod = "DP_WEXP_BEARER_US_PROD"
      auprod = "DP_WEXP_BEARER_AU_PROD"
    }
    x-csrf-token_name = {
      # dev    = "DP_X_CSRF_TOKEN_US_DEV"
      # qa     = "DP_X_CSRF_TOKEN_US_QA"
      usstg  = "DP_X_CSRF_TOKEN_US_STG"
      eustg  = "DP_X_CSRF_TOKEN_EU_STG"
      euprod = "DP_X_CSRF_TOKEN_EU_PROD"
      usprod = "DP_X_CSRF_TOKEN_US_PROD"
      auprod = "DP_X_CSRF_TOKEN_AU_PROD"
    }
    Authorization_name = {
      # dev    = "DP_BEARER_US_DEV"
      # qa     = "DP_BEARER_US_QA"
      usstg  = "DP_BEARER_US_STG"
      eustg  = "DP_BEARER_EU_STG"
      euprod = "DP_BEARER_EU_PROD"
      usprod = "DP_BEARER_US_PROD"
      auprod = "DP_BEARER_AU_PROD"
      sgprod = "DP_BEARER_SG_PROD"
    }
    referer_name = {
      euprod = "REFERER_EU_PROD"
      usprod = "REFERER_US_PROD"
      auprod = "REFERER_AU_PROD"
      sgprod = "REFERER_SG_PROD"
    }
    DATABRICKS_TARGET_INSTANCE = {
      # qa     = "DATABRICKS_TARGET_INSTANCE_US_QA"
      euprod = "DATABRICKS_TARGET_INSTANCE_WE_PROD"
      usprod = "DATABRICKS_TARGET_INSTANCE_US_PROD"
      auprod = "DATABRICKS_TARGET_INSTANCE_AU_PROD"
    }
    DATABRICKS_TARGET_INSTANCE_ID = {
      # qa     = "aa643668-272a-4afd-9893-0c8f732c4aaa"
      euprod = "427caab1-d8cd-42af-aa8f-2fc59c7e2333"
      usprod = "689babb5-55a7-4cce-b101-956e923e9809"
      auprod = "89ed7430-c62d-4858-847d-324b5866bf8c"
    }
    MFE_V2_DATABRICKS_TARGET_INSTANCE = {
      eustg  = "MFE_V2_DATABRICKS_TARGET_INSTANCE_EU_STG"
      usprod = "MFE_V2_DATABRICKS_TARGET_INSTANCE_US_PROD"
    }
    MFE_V2_DATABRICKS_TARGET_INSTANCE_ID = {
      eustg  = "dbxwbeustg003"
      usprod = "dbxwbusprod003"
    }    
  }
}

variable "synthetics_test_login" {
  default = {
    team_2 = {
      team_name = "TEAM_NAME_4"
      services = [
        {
          name        = "idbroker"
          pager_group = ""
          tag_ciid = {
            us = "CI116457338"
            au = "CI116457340"
            eu = "CI116457342"
            sg = "CI116457344"
          }
          synthetic_test_url_prefix = "dp-idbroker"          
          synthetic_oauth_login_test = [
            {
              url_suffix    = "-pwclabs.pwcglb.com/api/v1/public/login"
              type          = "login"
              auth_username = "wdatadogte001"
              auth_password = "{{ DP_DATADOG_PASSWORD }}"
              config_variable = [
                {
                  type = "custom"
                  name = "DP_DATADOG_PASSWORD"
                  id = "ca20c0c6-3ee5-43b4-a514-e38537be11e2"
                }
              ]
              request_definition = {
                  method = "GET"
                  no_saving_response_body = true
                  body = null
                }
              assertion = [
                {                          
                  type     = "statusCode"
                  operator = "is"
                  target   = "204"
                  property = null
                  targetjsonpath = []
                },
                {                          
                  type     = "header"
                  operator = "contains"
                  target   = "Bearer"
                  property = "authorization"
                  targetjsonpath = []
                },
                {                          
                  type     = "responseTime"
                  operator = "lessThan"
                  target   = "10000"
                  property = null
                  targetjsonpath = []
                },
              ]
              request_headers = {}
              options_list = {
                tick_every  = 900
                # retry_count    = 3
                # retry_interval = 300
              } 
              regions_envs = [
                { location = "us", env = "dev", create_test = true, create_slo = true },
                { location = "us", env = "qa", create_test = true, create_slo = true },
                #{ location = "us", env = "uat", create_test = true, create_slo = true },
                { location = "us", env = "stg", create_test = true, create_slo = true },
                { location = "eu", env = "stg", create_test = true, create_slo = true },
                { location = "us", env = "prod", create_test = true, create_slo = true },
                { location = "eu", env = "prod", create_test = true, create_slo = true },
                { location = "au", env = "prod", create_test = true, create_slo = true },               
              ]
            }
          ]
        },
        {
          name        = "Workbench"
          pager_group = ""
          tag_ciid = {
            us = "CI116457407"
            au = "CI116457409"
            eu = "CI116457411"
            sg = "CI116457413"
          }
          synthetic_test_url_prefix = "workbench"          
          synthetic_oauth_login_test = [
            {
              url_suffix    = "-pwclabs.pwcglb.com/oauth/login"
              type          = "login"
              auth_username = "wdatadogte001"
              auth_password = "{{ DP_DATADOG_PASSWORD }}"
              config_variable = [
                {
                  type = "custom"
                  name = "DP_DATADOG_PASSWORD"
                  id = "ca20c0c6-3ee5-43b4-a514-e38537be11e2"
                }
              ]
              request_definition = {
                method = "GET"
                body = null
              }
              assertion = [
                {                          
                  type     = "statusCode"
                  operator = "is"
                  target   = "200"
                  property = null
                  targetjsonpath = []
                },
                {                          
                  type     = "responseTime"
                  operator = "lessThan"
                  target   = "10000"
                  property = null
                  targetjsonpath = []
                },
                {                          
                  type     = "body"
                  operator = "contains"
                  target   = "wexp-bearer"
                  property = null
                  targetjsonpath = []
                },
                {                          
                  type     = "body"
                  operator = "contains"
                  target   = "x-csrf-token"
                  property = null
                  targetjsonpath = []
                },
                {                          
                  type     = "body"
                  operator = "validatesJSONPath"
                  target   = null
                  property = null
                  targetjsonpath = [
                    {
                      operator = "is"
                      jsonpath = "$.status"
                      targetvalue = "200"
                    }
                  ]
                }
              ]
              request_headers = {
                accept-encoding = "gzip, deflate, br"
                connection = "keep-alive"
              }
              options_list = {
                tick_every  = 300
                # retry_count    = 3
                # retry_interval = 300
              } 
              
              regions_envs = [
                { location = "us", env = "dev", create_test = true, create_slo = true },
                { location = "us", env = "qa", create_test = true, create_slo = true },
                #{ location = "us", env = "uat", create_test = true, create_slo = true },
                { location = "us", env = "stg", create_test = true, create_slo = true },
                { location = "eu", env = "stg", create_test = true, create_slo = true },
                { location = "us", env = "prod", create_test = true, create_slo = true },
                { location = "eu", env = "prod", create_test = true, create_slo = true },
                { location = "au", env = "prod", create_test = true, create_slo = true },
              ]
            }
          ]      
          
        },
      ]
    }
  }
}


variable "synthetics_multi_api_test_val" {
  default = {
    team_1 = {
      team_name = "TEAM_NAME_1"
      synthetics = [
        {
          tag_ciid = {
            us = "CI58685180"
            au = "CI58685184"
            eu = "CI58685186"
            sg = "CI58685188"
          }
          service_name              = "vizinsights"
          synthetic_test_url_prefix = "vizinsights"
          synthetics_monitor = [
            {
              name    = "Vizinsights Power BI"
              message = " "
              notify = "@opsgenie-Notifier @teams-Orca_Prod_Alerts_Channel"       
              #synthetics_test_base_var = {
              #  dev    = "vizinsights-us-dev.lower-pwclabs.pwcglb.com"
              #  qa     = "vizinsights-us-qa.lower-pwclabs.pwcglb.com"
              #  usstg  = "vizinsights-us-stg.np-pwclabs.pwcglb.com"
              #  eustg  = "vizinsights-eu-stg.np-pwclabs.pwcglb.com"
              #  euprod = "vizinsights-eu.pwclabs.pwcglb.com"
              #  usprod = "vizinsights-us.pwclabs.pwcglb.com"
              #  auprod = "vizinsights-au.pwclabs.pwcglb.com"
              #}
              config_variable = [
                {
                  type = "global"
                  name = "Authorization"
                  id = "id"
                }
              ]
              options_list_tick_interval = 10800
              options_list_min_location_failed = 1
              options_list_min_failure_duration = 7200
              options_list_monitor_priority = 2
              api_step = [
                {
                  url_suffix = "-pwclabs.pwcglb.com"
                  step = [
                    {
                      name    = "Get File Extensions"
                      subtype = "http"
                      assertion = [
                        {
                          type           = "statusCode"
                          operator       = "is"
                          target         = "200"
                          property       = null
                          targetjsonpath = []
                        },
                        {
                          type           = "responseTime"
                          operator       = "lessThan"
                          target         = "5000"
                          property       = null
                          targetjsonpath = []
                        },
                        {
                          type           = "header"
                          operator       = "is"
                          target         = "application/json"
                          property       = "content-type"
                          targetjsonpath = []
                        }
                      ]
                      request_definition = {
                        method                  = "GET"
                        url_suffix              = "/api/v1/file-extensions"
                        no_saving_response_body = false
                        body                    = null
                      }

                      request_headers = {
                        wexp-bearer     = null
                        connection      = null
                        content-type    = null
                        accept-encoding = null
                        x-csrf-token    = null
                        Authorization   = "Authorization"
                      }
                      extracted_value = []

                    },
                    {
                      name    = "Get Power BI Engagement Metadata"
                      subtype = "http"
                      assertion = [
                        {
                          type           = "statusCode"
                          operator       = "is"
                          target         = "200"
                          property       = null
                          targetjsonpath = []
                        },
                        {
                          type           = "responseTime"
                          operator       = "lessThan"
                          target         = "5000"
                          property       = null
                          targetjsonpath = []
                        },
                        {
                          type           = "body"
                          operator       = "contains"
                          target         = "resourceName"
                          targetjsonpath = []
                        },
                      ]
                      request_definition = {
                        method     = "GET"
                        url_suffix = null
                        url_suffix_value = [
                          # "/api/v1/powerbi/clients/{{ VIZINSIGHTS_CLIENT_ID_US_DEV }}/engagements/{{ VIZINSIGHTS_ENGAGEMENT_ID_US_DEV }}",
                          # "/api/v1/powerbi/clients/00003134-093d-47fe-9d94-850fb8b6364a/engagements/d28e3f5e-17a9-42d0-a223-7fcf8b1ec784",
                          "/api/v1/powerbi/clients/000000dd-93d7-482b-8b7b-d9bebf96322f/engagements/90f296fb-5308-4e7c-a9a4-b55d6059e2b1",
                          "/api/v1/powerbi/clients/141eee91-1383-4011-8b8f-ae0c1f37c8b8/engagements/b0b39367-5623-4430-984f-3d92d55f082d",
                          "/api/v1/powerbi/clients/b5b50cd3-c271-4e1d-9b23-b2776120526f/engagements/830a02e3-4c33-47b3-a79c-7938b66cbf95",
                          "/api/v1/powerbi/clients/6705434a-741d-4da5-98eb-b6fa1898450f/engagements/072cd9a3-6fc7-4b1c-b74d-0b85b8fc861d",
                          "/api/v1/powerbi/clients/9deb5e6c-db75-4a4a-988c-97fc179af94b/engagements/f45c4b6b-2330-4822-8711-6d79521405dd"
                        ]
                        url_suffix_key = [
                          # "dev",
                          # "qa",
                          "usstg",
                          "eustg",
                          "euprod",
                          "usprod",
                          "auprod"
                        ]
                        no_saving_response_body = false
                        body                    = null
                      }

                      request_headers = {
                        wexp-bearer     = null
                        content-type    = null
                        x-csrf-token    = null
                        accept-encoding = null
                        connection      = null
                        Authorization   = "Authorization"
                      }
                      extracted_value = []


                    },
                    {
                      name    = "Get Power BI Reports"
                      subtype = "http"
                      assertion = [
                        {
                          type           = "statusCode"
                          operator       = "is"
                          target         = "200"
                          property       = null
                          targetjsonpath = []
                        },
                        {
                          type           = "responseTime"
                          operator       = "lessThan"
                          target         = "20000"
                          property       = null
                          targetjsonpath = []
                        },
                        {
                          type           = "header"
                          operator       = "is"
                          target         = "application/json"
                          property       = "content-type"
                          targetjsonpath = []
                        }
                      ]
                      request_definition = {
                        method     = "GET"
                        url_suffix = null
                        url_suffix_value = [
                          # "/api/v1/powerbi/clients/{{ VIZINSIGHTS_CLIENT_ID_US_DEV }}/engagements/{{ VIZINSIGHTS_ENGAGEMENT_ID_US_DEV }}/assets",
                          # "/api/v1/powerbi/clients/00003134-093d-47fe-9d94-850fb8b6364a/engagements/d28e3f5e-17a9-42d0-a223-7fcf8b1ec784/assets",
                          "/api/v1/powerbi/clients/000000dd-93d7-482b-8b7b-d9bebf96322f/engagements/90f296fb-5308-4e7c-a9a4-b55d6059e2b1/assets",
                          "/api/v1/powerbi/clients/141eee91-1383-4011-8b8f-ae0c1f37c8b8/engagements/b0b39367-5623-4430-984f-3d92d55f082d/assets",
                          "/api/v1/powerbi/clients/b5b50cd3-c271-4e1d-9b23-b2776120526f/engagements/830a02e3-4c33-47b3-a79c-7938b66cbf95/assets",
                          "/api/v1/powerbi/clients/6705434a-741d-4da5-98eb-b6fa1898450f/engagements/072cd9a3-6fc7-4b1c-b74d-0b85b8fc861d/assets",
                          "/api/v1/powerbi/clients/9deb5e6c-db75-4a4a-988c-97fc179af94b/engagements/f45c4b6b-2330-4822-8711-6d79521405dd/assets"
                        ]
                        url_suffix_key = [
                          # "dev",
                          # "qa",
                          "usstg",
                          "eustg",
                          "euprod",
                          "usprod",
                          "auprod"
                        ]
                        no_saving_response_body = false
                        body                    = null
                      }

                      request_headers = {
                        wexp-bearer     = null
                        content-type    = null
                        x-csrf-token    = null
                        accept-encoding = null
                        connection      = null
                        Authorization   = "Authorization"
                      }
                      extracted_value = [{
                        name = "ASSET_ID"
                        type = "http_body"
                        parser = {
                          type  = "json_path"
                          value = "$[0].id"
                        }

                      }]


                    },
                    {
                      name    = "Get Power BI Datasets"
                      subtype = "http"
                      assertion = [
                        {
                          type           = "statusCode"
                          operator       = "is"
                          target         = "200"
                          property       = null
                          targetjsonpath = []
                        },
                        {
                          type           = "responseTime"
                          operator       = "lessThan"
                          target         = "20000"
                          property       = null
                          targetjsonpath = []
                        },
                        {
                          type           = "header"
                          operator       = "is"
                          target         = "application/json"
                          property       = "content-type"
                          targetjsonpath = []
                        }
                      ]
                      request_definition = {
                        method = "GET"
                        url_suffix_value = [
                          # "/api/v1/powerbi/clients/{{ VIZINSIGHTS_CLIENT_ID_US_DEV }}/engagements/{{ VIZINSIGHTS_ENGAGEMENT_ID_US_DEV }}/dataset",
                          # "/api/v1/powerbi/clients/00003134-093d-47fe-9d94-850fb8b6364a/engagements/d28e3f5e-17a9-42d0-a223-7fcf8b1ec784/dataset",
                          "/api/v1/powerbi/clients/000000dd-93d7-482b-8b7b-d9bebf96322f/engagements/90f296fb-5308-4e7c-a9a4-b55d6059e2b1/dataset",
                          "/api/v1/powerbi/clients/141eee91-1383-4011-8b8f-ae0c1f37c8b8/engagements/b0b39367-5623-4430-984f-3d92d55f082d/dataset",
                          "/api/v1/powerbi/clients/b5b50cd3-c271-4e1d-9b23-b2776120526f/engagements/830a02e3-4c33-47b3-a79c-7938b66cbf95/dataset",
                          "/api/v1/powerbi/clients/6705434a-741d-4da5-98eb-b6fa1898450f/engagements/072cd9a3-6fc7-4b1c-b74d-0b85b8fc861d/dataset",
                          "/api/v1/powerbi/clients/9deb5e6c-db75-4a4a-988c-97fc179af94b/engagements/f45c4b6b-2330-4822-8711-6d79521405dd/dataset"
                        ]
                        url_suffix = null
                        url_suffix_key = [
                          # "dev",
                          # "qa",
                          "usstg",
                          "eustg",
                          "euprod",
                          "usprod",
                          "auprod"
                        ]
                        no_saving_response_body = false
                        body                    = null
                      }

                      request_headers = {
                        wexp-bearer     = null
                        content-type    = null
                        x-csrf-token    = null
                        accept-encoding = null
                        connection      = null
                        Authorization   = "Authorization"
                      }
                      extracted_value = []
                    },
                    {
                      name    = "Get Power BI Roles"
                      subtype = "http"
                      assertion = [
                        {
                          type           = "statusCode"
                          operator       = "is"
                          target         = "200"
                          property       = null
                          targetjsonpath = []
                        },
                        {
                          type           = "responseTime"
                          operator       = "lessThan"
                          target         = "20000"
                          property       = null
                          targetjsonpath = []
                        },
                        {
                          type           = "header"
                          operator       = "is"
                          target         = "application/json"
                          property       = "content-type"
                          targetjsonpath = []
                        }
                      ]
                      request_definition = {
                        method = "GET"
                        url_suffix_value = [
                          # "/api/v1/powerbi/clients/{{ VIZINSIGHTS_CLIENT_ID_US_DEV }}/engagements/{{ VIZINSIGHTS_ENGAGEMENT_ID_US_DEV }}/roles",
                          # "/api/v1/powerbi/clients/00003134-093d-47fe-9d94-850fb8b6364a/engagements/d28e3f5e-17a9-42d0-a223-7fcf8b1ec784/roles",
                          "/api/v1/powerbi/clients/000000dd-93d7-482b-8b7b-d9bebf96322f/engagements/90f296fb-5308-4e7c-a9a4-b55d6059e2b1/roles",
                          "/api/v1/powerbi/clients/141eee91-1383-4011-8b8f-ae0c1f37c8b8/engagements/b0b39367-5623-4430-984f-3d92d55f082d/roles",
                          "/api/v1/powerbi/clients/b5b50cd3-c271-4e1d-9b23-b2776120526f/engagements/830a02e3-4c33-47b3-a79c-7938b66cbf95/roles",
                          "/api/v1/powerbi/clients/6705434a-741d-4da5-98eb-b6fa1898450f/engagements/072cd9a3-6fc7-4b1c-b74d-0b85b8fc861d/roles",
                          "/api/v1/powerbi/clients/9deb5e6c-db75-4a4a-988c-97fc179af94b/engagements/f45c4b6b-2330-4822-8711-6d79521405dd/roles"
                        ]
                        url_suffix              = null
                        no_saving_response_body = false
                        url_suffix_key = [
                          # "dev",
                          # "qa",
                          "usstg",
                          "eustg",
                          "euprod",
                          "usprod",
                          "auprod"
                        ]
                        body = null
                      }

                      request_headers = {
                        wexp-bearer     = null
                        content-type    = null
                        x-csrf-token    = null
                        accept-encoding = null
                        connection      = null
                        Authorization   = "Authorization"
                      }
                      extracted_value = []
                    },
                    {
                      name    = "Get Power BI Report Token"
                      subtype = "http"
                      assertion = [
                        {
                          type           = "statusCode"
                          operator       = "is"
                          target         = "200"
                          property       = null
                          targetjsonpath = []
                        },
                        {
                          type           = "responseTime"
                          operator       = "lessThan"
                          target         = "20000"
                          property       = null
                          targetjsonpath = []
                        },
                        {
                          type           = "header"
                          operator       = "is"
                          target         = "application/json"
                          property       = "content-type"
                          targetjsonpath = []
                        },
                        {
                          type           = "body"
                          operator       = "contains"
                          target         = "tokenId"
                          property       = null
                          targetjsonpath = []
                        }
                      ]
                      request_definition = {
                        method = "POST"
                        url_suffix_value = [
                          # "/api/v1/powerbi/clients/{{ VIZINSIGHTS_CLIENT_ID_US_DEV }}/engagements/{{ VIZINSIGHTS_ENGAGEMENT_ID_US_DEV }}/assets/{{ ASSET_ID }}/token",
                          # "/api/v1/powerbi/clients/00003134-093d-47fe-9d94-850fb8b6364a/engagements/d28e3f5e-17a9-42d0-a223-7fcf8b1ec784/assets/{{ ASSET_ID }}/token",
                          "/api/v1/powerbi/clients/000000dd-93d7-482b-8b7b-d9bebf96322f/engagements/90f296fb-5308-4e7c-a9a4-b55d6059e2b1/assets/{{ ASSET_ID }}/token",
                          "/api/v1/powerbi/clients/141eee91-1383-4011-8b8f-ae0c1f37c8b8/engagements/b0b39367-5623-4430-984f-3d92d55f082d/assets/{{ ASSET_ID }}/token",
                          "/api/v1/powerbi/clients/b5b50cd3-c271-4e1d-9b23-b2776120526f/engagements/830a02e3-4c33-47b3-a79c-7938b66cbf95/assets/{{ ASSET_ID }}/token",
                          "/api/v1/powerbi/clients/6705434a-741d-4da5-98eb-b6fa1898450f/engagements/072cd9a3-6fc7-4b1c-b74d-0b85b8fc861d/assets/{{ ASSET_ID }}/token",
                          "/api/v1/powerbi/clients/9deb5e6c-db75-4a4a-988c-97fc179af94b/engagements/f45c4b6b-2330-4822-8711-6d79521405dd/assets/{{ ASSET_ID }}/token"
                        ]
                        no_saving_response_body = true
                        url_suffix              = null
                        url_suffix_key = [
                          # "dev",
                          # "qa",
                          "usstg",
                          "eustg",
                          "euprod",
                          "usprod",
                          "auprod"
##discontinued

    team_4 = {

      team_name = "TEAM_NAME_4"

      synthetics = [

        {

          tag_ciid = {

            us = "CI116457421"

            au = "CI41101427"

            eu = "CI41101419"

            sg = "CI58685029"

          }

          service_name              = "ms-teams-wrapper"

          synthetic_test_url_prefix = "workbench"

          synthetics_monitor = [

            {

              name    = "Provisioning ms-teams-wrapper"

              message = "ms-teams-wrapper Provisioning Failed"

              notify = "@opsgenie-Notifier"

              #synthetics_test_base_var = {

              #  dev    = "workbench-us-dev.lower-pwclabs.pwcglb.com"

              #  qa     = "workbench-us-qa.lower-pwclabs.pwcglb.com"

              #  usstg  = "workbench-us-stg.np-pwclabs.pwcglb.com"

              #  eustg  = "workbench-eu-stg.np-pwclabs.pwcglb.com"

              #  euprod = "workbench-eu.pwclabs.pwcglb.com"

              #  usprod = "workbench-us.pwclabs.pwcglb.com"

              #  auprod = "workbench-au.pwclabs.pwcglb.com"

              #}

              config_variable = [

                {

                  type = "text"

                  name = "WORKSPACE_NAME"

                  pattern = "SRE_Workspace_{{ date(0d, DD_MM_YYYY_HH_MM) }}_{{ alphanumeric(5) }}"

                },

                {

                  type = "global"

                  name = "wexp-bearer"

                  id = "id"

                },

                {

                  type = "global"

                  name = "x-csrf-token"

                  id = "id"

                },

                {

                  type = "global"

                  name = "Authorization"

                  id = "id"

                },   

              ]

              options_list_tick_interval = 7200

              options_list_min_location_failed = 1

              options_list_min_failure_duration = 7200

              options_list_monitor_priority = 2

              api_step = [

                {

                  url_suffix = "-pwclabs.pwcglb.com"

                  step = [

                    {

                      name    = "Create an Engagement"

                      subtype = "http"

                      assertion = [

                        {

                          type           = "statusCode"

                          operator       = "is"

                          target         = "200"

                          property       = null

                          targetjsonpath = []

                        },

                      ]

                      request_definition = {

                        method                  = "POST"

                        url_suffix              = "/api/v1/engagements"

                        no_saving_response_body = false

                        body                    = <<-EOD

                            {

                              "name": "{{ WORKSPACE_NAME }}",

                              "engagementType": "Other",

                              "clientId": "2e16783a-6a0b-4073-94b3-5bbf05d8bf60",

                              "clientName": "The Boring Company",

                              "userId": "wdatadogte001",

                              "workspaceType": "Client Engagement",

                              "territory": "United States",

                              "wbsCode": "01234567890",

                              "lineOfService": "Assurance",

                              "apptioId": "xx000",

                              "dataConsentLevel": "",

                              "dataClassification": "DC2",

                              "teamMembers": [],

                              "leader": {

                                  "pwcGuid": "wdatadogte001",

                                  "name":"workbench datadogtest",

                                  "email":"workbench.datadogtest@us.pwc.com",

                                  "roles": [

                                      "Leader"        ]

                              },

                              "startDate": "11/01/2021",

                              "endDate": "12/31/2021"

                            }

                            EOD

                      }

                      request_headers = {

                        wexp-bearer     = "wexp-bearer"

                        connection      = "keep-alive"

                        content-type    = "application/json"

                        accept-encoding = "gzip, deflate, br"

                        x-csrf-token    = "x-csrf-token"

                        Authorization   = null

                      }

                      extracted_value = [

                        {

                          name = "ENGAGEMENT_ID"

                          type = "http_body"

                          parser = {

                            type  = "json_path"

                            value = "$.data.data.id"

                          }

                        }                        

                      ]

                      retry = [{

                        count    = 5

                        interval = 5000

                      }]

                    },

                    {

                      name          = "GET FEATURE SWITCH"

                      subtype       = "http"

                      allow_failure = true

                      is_critical   = true

                      assertion = [

                        {

                          type           = "statusCode"

                          operator       = "is"

                          target         = "200"

                          property       = null

                          targetjsonpath = []

                        }

                      ]

                      request_definition = {

                        method                  = "GET"

                        url_suffix              = "/api/v1/engagements/{{ ENGAGEMENT_ID }}/features"

                        no_saving_response_body = false

                        body                    = null

                      }

                      request_query = {

                        searchName = "Microsoft Teams"

                      }



                      request_headers = {

                        wexp-bearer     = "wexp-bearer"

                        content-type    = "application/json"

                        x-csrf-token    = "x-csrf-token"

                        accept-encoding = "gzip, deflate, br"

                        accept          = "application/json"

                        connection      = null

                        Authorization   = null

                      }

                      extracted_value = [

                        {

                          name = "FEATURE_ID"

                          type = "http_body"

                          parser = {

                            type  = "json_path"

                            value = "$.data[0].definition.featureId"

                          }

                        }

                      ]

                      retry = [{

                        count    = 5

                        interval = 5000

                      }]

                    },

                    {

                      name          = "Provision MS Teams Wrapper service"

                      subtype       = "http"

                      allow_failure = true

                      is_critical   = true

                      assertion = [

                        {

                          type           = "statusCode"

                          operator       = "is"

                          target         = "200"

                          property       = null

                          targetjsonpath = []

                        },

                        {

                          type     = "body"

                          operator = "validatesJSONPath"

                          target   = null

                          property = null

                          targetjsonpath = [

                            {

                              operator    = "contains"

                              jsonpath    = "$.data.status"

                              targetvalue = "PROVISIONING"

                            }

                          ]

                        },

                      ]

                      request_definition = {

                        method                  = "POST"

                        url_suffix              = "/api/v1/engagements/{{ ENGAGEMENT_ID }}/features"

                        no_saving_response_body = false

                        body                    = <<-EOD

                            {                           

                              "formFields": [

                                              {

                                                  "formId": "2",

                                                  "isEditable": false,

                                                  "isSelected": false,

                                                  "label": "I have read and agree to follow the Microsoft Teams Business Rules",

                                                  "name": "confirm2",

                                                  "type": "CHECKBOX",

                                                  "validation": {

                                                      "isRequired": true

                                                    }

                                              }

                                          ],

                              "featureId": "{{ FEATURE_ID }}",

                              "engagementId":"{{ ENGAGEMENT_ID }}"                            

                            }

                            EOD

                        allow_insecure          = true

                      }



                      request_headers = {

                        wexp-bearer     = "wexp-bearer"

                        content-type    = "application/json"

                        x-csrf-token    = "x-csrf-token"

                        accept-encoding = null

                        connection      = null

                        Authorization   = null

                      }

                      extracted_value = []

                    },

                    {

                      name    = "Wait for 3 minutes"

                      subtype = "wait"

                      value   = 180

                      assertion = []                     

                    }, 

                    {

                      name    = "Wait for 2 minutes"

                      subtype = "wait"

                      value   = 120

                      assertion = []                     

                    },

                    {

                    name    = "Check provisioning"

                    allow_failure = true

                    is_critical   = true

                    subtype = "http"

                    assertion = [

                      {

                        type           = "statusCode"

                        operator       = "is"

                        target         = "200"

                        property       = null

                        targetjsonpath = []

                      },

                      {

                        type           = "header"

                        operator       = "is"

                        target         = "application/json"

                        property       = "content-type"

                        targetjsonpath = []

                      },

                      {

                        type     = "body"

                        operator = "validatesJSONPath"

                        target   = null

                        property = null

                        targetjsonpath = [

                          {

                            operator    = "is"

                            jsonpath    = "$[0].status"

                            targetvalue = "READY"

                          }

                        ]

                      },                      

                    ]

                    request_definition = {

                      method                  = "GET"

                      synthetic_test_url_prefix = "service-provisioning-api"

                      url_suffix              = "/api/v1/serviceProvisioning/engagements/{{ ENGAGEMENT_ID }}/feature-status"

                      no_saving_response_body = false

                      body                    = null

                    }



                    request_headers = {

                      wexp-bearer     = null

                      content-type    = null

                      x-csrf-token    = null

                      accept-encoding = null

                      connection      = null

                      Authorization   = "Authorization"

                    }

                    extracted_value = []

                      retry = [{

                      count    = 5

                      interval = 5000

                    }]

                    },                   

                    {

                    name    = "Archive Engagement"

                    subtype = "http"

                    allow_failure = true

                    is_critical   = false

                    assertion = [

                      {

                        type           = "statusCode"

                        operator       = "is"

                        target         = "200"

                        property       = null

                        targetjsonpath = []

                      },

                      {

                        type     = "body"

                        operator = "validatesJSONPath"

                        target   = null

                        property = null

                        targetjsonpath = [

                          {

                            operator    = "contains"

                            jsonpath    = "$.data.active"

                            targetvalue = "false"

                          }

                        ]

                      },

                    ]

                    request_definition = {

                      method                  = "PATCH"

                      url_suffix              = "/api/v1/engagements/{{ ENGAGEMENT_ID }}/archive"

                      no_saving_response_body = false

                      body                    = null

                    }



                    request_headers = {

                      wexp-bearer     = "wexp-bearer"

                      content-type    = " application/json"

                      x-csrf-token    = "x-csrf-token"

                      accept-encoding = null

                      connection      = null

                      Authorization   = null

                    }

                    extracted_value = []

                    },

                    {

                      name    = "Delete Engagement"

                      subtype = "http"

                      assertion = [

                        {

                          type           = "statusCode"

                          operator       = "is"

                          target         = "200"

                          property       = null

                          targetjsonpath = []

                        },

                        {

                          type     = "body"

                          operator = "validatesJSONPath"

                          target   = null

                          property = null

                          targetjsonpath = [

                            {

                              operator    = "contains"

                              jsonpath    = "$.data"

                              targetvalue = "deletion"

                            }

                          ]

                        },

                      ]

                      request_definition = {

                        method                  = "DELETE"

                        url_suffix              = "/api/v1/engagements/{{ ENGAGEMENT_ID }}"

                        no_saving_response_body = true

                        body                    = null

                      }



                      request_headers = {

                        wexp-bearer     = "wexp-bearer"

                        content-type    = "application/json"

                        x-csrf-token    = "x-csrf-token"

                        accept-encoding = null

                        connection      = null

                        Authorization   = null

                      }

                      extracted_value = []

                    }

                  ]

                  regions_envs : [

                    #{ location = "us", env = "dev", create_test = true },

                    # { location = "us", env = "qa", create_test = true },

                    { location = "us", env = "stg", create_test = true },

                    { location = "eu", env = "stg", create_test = true },

                    { location = "eu", env = "prod", create_test = true },

                    { location = "us", env = "prod", create_test = true },

                    { location = "au", env = "prod", create_test = true },

                    #{ location = "sg", env = "prod", create_test = true }

                  ]

                }

              ]

            }

          ]

        },

        {

          tag_ciid = {

            us = "CI43816433"

            au = "CI58684983"

            eu = "CI58684985"

            sg = "CI58684987"

          }

          service_name              = "wbservice-databricks"

          synthetic_test_url_prefix = "workbench"

          synthetics_monitor = [

            {

              name    = "Provisioning Databricks Citizen"

              message = "Databrick Provisioning failed"

              notify = "@pallab.p.ray@pwc.com @opsgenie-Notifier"

              #synthetics_test_base_var = {

              #}

              config_variable = [

                {

                  type = "text"

                  name = "WORKSPACE_NAME"

                  pattern = "SRE_Workspace_{{ date(0d, DD_MM_YYYY_HH_MM) }}_{{ alphanumeric(5) }}"

                },

                {

                  type = "global"

                  name = "wexp-bearer"

                  id = "id"

                },

                {

                  type = "global"

                  name = "x-csrf-token"

                  id = "id"

                },

                {

                  type = "global"

                  name = "Authorization"

                  id = "id"

                },

                {

                  type = "custom"

                  name = "DATABRICKS_FEATURE_ID"

                  id = "9ca07f2d-b47b-4d42-acfe-71c32fd3c163"

                },                

              ]

              

              options_list_tick_interval = 7200

              options_list_min_location_failed = 1

              options_list_min_failure_duration = 7200

              options_list_monitor_priority = 3

              api_step = [

                {

                  url_suffix = "-pwclabs.pwcglb.com"

                  step = [

                    {

                      name    = "Create Engagement"

                      subtype = "http"

                      assertion = [

                        {

                          type           = "statusCode"

                          operator       = "is"

                            target         = "200"

                          property       = null

                          targetjsonpath = []

                        },                        

                      ]

                      request_definition = {

                        method     = "POST"

                        #synthetic_test_url_prefix = "workbench"

                        url_suffix = "/api/v1/engagements"

                        url_suffix_value = []

                        no_saving_response_body = false

                        body = "file_path"

                        body_file_path = "data/Databricks_Provisioning/Workbench_DB_ENG_Creation"

                      }

                      request_headers = {

                        wexp-bearer     = "wexp-bearer"

                        connection      = null

                        content-type    = "application/json"

                        accept-encoding = null

                        x-csrf-token    = "x-csrf-token"

                        Authorization   = null

                      }

                      extracted_value = [

                        {

                          name = "ENGAGEMENT_ID"

                          type = "http_body"

                          parser = {

                            type  = "json_path"

                            value = "$.data.data.id"

                          }

                        }

                      ]

                    },

                    {

                      name    = "Provision Databricks"

                      allow_failure = true

                      is_critical   = true

                      subtype = "http"

                      assertion = [

                        {

                          type           = "statusCode"

                          operator       = "is"

                          target         = "200"

                          property       = null

                          targetjsonpath = []

                        },                        

                      ]

                      request_definition = {

                        method                  = "POST"

                        url_suffix              = "/api/v1/engagements/{{ ENGAGEMENT_ID }}/features"

                        no_saving_response_body = false

                        body                    = "multi_file_path"

                        body_file_path          = null

                        body_file_path_value    = [

                          # "data/Databricks_Provisioning/Databricks_Citizen_Provisioning_body_QA",

                          "data/Databricks_Provisioning/Databricks_Citizen_Provisioning_body_PROD_US",

                          "data/Databricks_Provisioning/Databricks_Citizen_Provisioning_body_PROD_EU",

                          "data/Databricks_Provisioning/Databricks_Citizen_Provisioning_body_PROD_AU"

                        ] 

                        body_file_path_key      = [

                          # "qa",

                          "usprod",

                          "euprod",

                          "auprod"

                        ] 

                      }



                      request_headers = {

                        wexp-bearer     = "wexp-bearer"

                        content-type    = "application/json"

                        x-csrf-token    = "x-csrf-token"

                        accept-encoding = null

                        connection      = null

                        Authorization   = null

                      }

                      extracted_value = []

                    },

                    {

                      name    = "Check provisioning"

                      allow_failure = true

                      is_critical   = false

                      subtype = "http"

                      assertion = [

                        {

                          type           = "statusCode"

                          operator       = "is"

                          target         = "200"

                          property       = null

                          targetjsonpath = []

                        },

                        {

                          type           = "header"

                          operator       = "is"

                          target         = "application/json"

                          property       = "content-type"

                          targetjsonpath = []

                        },

                        {

                          type     = "body"

                          operator = "validatesJSONPath"

                          target   = null

                          property = null

                          targetjsonpath = [

                            {

                              operator    = "is"

                              jsonpath    = "$[0].status"

                              targetvalue = "READY"

                            }

                          ]

                        },                      

                      ]

                      request_definition = {

                        method                  = "GET"

                        synthetic_test_url_prefix = "service-provisioning-api"

                        url_suffix              = "/api/v1/serviceProvisioning/engagements/{{ ENGAGEMENT_ID }}/feature-status"

                        no_saving_response_body = false

                        body                    = null

                      }



                      request_headers = {

                        wexp-bearer     = null

                        content-type    = null

                        x-csrf-token    = null

                        accept-encoding = null

                        connection      = null

                        Authorization   = "Authorization"

                      }

                      extracted_value = []

                       retry = [{

                        count    = 5

                        interval = 5000

                      }]

                    },

                    {

                      name    = "Check provisioning"

                      allow_failure = true

                      is_critical   = false

                      subtype = "http"

                      assertion = [

                        {

                          type           = "statusCode"

                          operator       = "is"

                          target         = "200"

                          property       = null

                          targetjsonpath = []

                        },

                        {

                          type           = "header"

                          operator       = "is"

                          target         = "application/json"

                          property       = "content-type"

                          targetjsonpath = []

                        },

                        {

                          type     = "body"

                          operator = "validatesJSONPath"

                          target   = null

                          property = null

                          targetjsonpath = [

                            {

                              operator    = "is"

                              jsonpath    = "$[0].status"

                              targetvalue = "READY"

                            }

                          ]

                        },                      

                      ]

                      request_definition = {

                        method                  = "GET"

                        synthetic_test_url_prefix = "service-provisioning-api"

                        url_suffix              = "/api/v1/serviceProvisioning/engagements/{{ ENGAGEMENT_ID }}/feature-status"

                        no_saving_response_body = false

                        body                    = null

                      }



                      request_headers = {

                        wexp-bearer     = null

                        content-type    = null

                        x-csrf-token    = null

                        accept-encoding = null

                        connection      = null

                        Authorization   = "Authorization"

                      }

                      extracted_value = []

                       retry = [{

                        count    = 5

                        interval = 5000

                      }]

                    },

                    {

                      name    = "Check provisioning"

                      allow_failure = true

                      is_critical   = false

                      subtype = "http"

                      assertion = [

                        {

                          type           = "statusCode"

                          operator       = "is"

                          target         = "200"

                          property       = null

                          targetjsonpath = []

                        },

                        {

                          type           = "header"

                          operator       = "is"

                          target         = "application/json"

                          property       = "content-type"

                          targetjsonpath = []

                        },

                        {

                          type     = "body"

                          operator = "validatesJSONPath"

                          target   = null

                          property = null

                          targetjsonpath = [

                            {

                              operator    = "is"

                              jsonpath    = "$[0].status"

                              targetvalue = "READY"

                            }

                          ]

                        },                      

                      ]

                      request_definition = {

                        method                  = "GET"

                        synthetic_test_url_prefix = "service-provisioning-api"

                        url_suffix              = "/api/v1/serviceProvisioning/engagements/{{ ENGAGEMENT_ID }}/feature-status"

                        no_saving_response_body = false

                        body                    = null

                      }



                      request_headers = {

                        wexp-bearer     = null

                        content-type    = null

                        x-csrf-token    = null

                        accept-encoding = null

                        connection      = null

                        Authorization   = "Authorization"

                      }

                      extracted_value = []

                       retry = [{

                        count    = 5

                        interval = 5000

                      }]

                    },

                    {

                      name    = "Check provisioning"

                      allow_failure = true

                      is_critical   = true

                      subtype = "http"

                      assertion = [

                        {

                          type           = "statusCode"

                          operator       = "is"

                          target         = "200"

                          property       = null

                          targetjsonpath = []

                        },

                        {

                          type           = "header"

                          operator       = "is"

                          target         = "application/json"

                          property       = "content-type"

                          targetjsonpath = []

                        },

                        {

                          type     = "body"

                          operator = "validatesJSONPath"

                          target   = null

                          property = null

                          targetjsonpath = [

                            {

                              operator    = "is"

                              jsonpath    = "$[0].status"

                              targetvalue = "READY"

                            }

                          ]

                        },                      

                      ]

                      request_definition = {

                        method                  = "GET"

                        synthetic_test_url_prefix = "service-provisioning-api"

                        url_suffix              = "/api/v1/serviceProvisioning/engagements/{{ ENGAGEMENT_ID }}/feature-status"

                        no_saving_response_body = false

                        body                    = null

                      }



                      request_headers = {

                        wexp-bearer     = null

                        content-type    = null

                        x-csrf-token    = null

                        accept-encoding = null

                        connection      = null

                        Authorization   = "Authorization"

                      }

                      extracted_value = []

                       retry = [{

                        count    = 5

                        interval = 5000

                      }]

                    },

                    {

                      name    = "Achieve Engagement"

                      allow_failure = true

                      is_critical   = false

                      subtype = "http"

                      assertion = [

                        {

                          type           = "statusCode"

                          operator       = "is"

                          target         = "200"

                          property       = null

                          targetjsonpath = []

                        },

                        {

                          type     = "body"

                          operator = "validatesJSONPath"

                          target   = null

                          property = null

                          targetjsonpath = [

                            {

                              operator    = "contains"

                              jsonpath    = "$.data.active"

                              targetvalue = "false"

                            }

                          ]

                        },                      

                      ]

                      request_definition = {

                        method                  = "PATCH"

                        url_suffix              = "/api/v1/engagements/{{ ENGAGEMENT_ID }}/archive"

                        no_saving_response_body = false

                        body                    = null

                      }



                      request_headers = {

                        wexp-bearer     = "wexp-bearer"

                        content-type    = "application/json"

                        x-csrf-token    = "x-csrf-token"

                        accept-encoding = null

                        connection      = null

                        Authorization   = null

                      }

                      extracted_value = []

                    },

                    {

                      name    = "Delete Engagement"

                      subtype = "http"

                      assertion = [

                        {

                          type           = "statusCode"

                          operator       = "is"

                          target         = "200"

                          property       = null

                          targetjsonpath = []

                        },

                        {

                          type     = "body"

                          operator = "validatesJSONPath"

                          target   = null

                          property = null

                          targetjsonpath = [

                            {

                              operator    = "contains"

                              jsonpath    = "$.data"

                              targetvalue = "deletion "

                            }

                          ]

                        },                      

                      ]

                      request_definition = {

                        method                  = "DELETE"

                        url_suffix              = "/api/v1/engagements/{{ ENGAGEMENT_ID }}"

                        no_saving_response_body = false

                        body                    = null

                      }



                      request_headers = {

                        wexp-bearer     = "wexp-bearer"

                        content-type    = "application/json"

                        x-csrf-token    = "x-csrf-token"

                        accept-encoding = null

                        connection      = null

                        Authorization   = null

                      }

                      extracted_value = []

                    },

                  ]

                  regions_envs : [

                    # { location = "us", env = "qa", create_test = true },

                    { location = "us", env = "prod", create_test = true, tag_snow = true },

                    { location = "eu", env = "prod", create_test = true,  tag_snow = true },

                    { location = "au", env = "prod", create_test = true,  tag_snow = true },

                  ]

                }

              ]

            }

          ]

        },

variable "global_variable" {

  default = {

    global_variable = {

      value = [

        {

          name      = "WEXP_BEARER"

          type      = "dynamic"

          test_name = "workbench"

          parse_test_options = [{

            type = "http_body"

            field = null

            parser = [{

              type  = "json_path"

              value = "$.data['wexp-bearer']"

            }]

          }]

          regions_envs = [

            { location = "us", env = "dev", scope = "deploy", create_test = true },

            { location = "us", env = "qa", scope = "deploy", create_test = true },

            { location = "us", env = "stg", scope = "deploy", create_test = true },

            { location = "eu", env = "stg", scope = "deploy", create_test = true },

            { location = "us", env = "prod", scope = "deploy", create_test = true },

            { location = "eu", env = "prod", scope = "deploy", create_test = true },

            { location = "au", env = "prod", scope = "deploy", create_test = true },

          ]

        },

        {

          name      = "X_CSRF_TOKEN"

          type      = "dynamic"

          test_name = "workbench"

          parse_test_options = [{

            type = "http_body"

            parser = [{

              type  = "json_path"

              value = "$.data['x-csrf-token']"

            }]

          }]

          regions_envs = [

            { location = "us", env = "dev", scope = "deploy", create_test = true },

            { location = "us", env = "qa", scope = "deploy", create_test = true },

            { location = "us", env = "stg", scope = "deploy", create_test = true },

            { location = "eu", env = "stg", scope = "deploy", create_test = true },

            { location = "us", env = "prod", scope = "deploy", create_test = true },

            { location = "eu", env = "prod", scope = "deploy", create_test = true },

            { location = "au", env = "prod", scope = "deploy", create_test = true },

          ]

        },

        

        {

          name      = "BEARER"

          type      = "dynamic"

          test_name = "idbroker"

          parse_test_options = [{

            type = "http_header"

            field = "authorization"

            parser = [{

              type  = "raw"              

            }]

          }]

          regions_envs = [

            { location = "us", env = "dev", scope = "deploy", create_test = true },

            { location = "us", env = "qa", scope = "deploy", create_test = true },

            { location = "us", env = "stg", scope = "deploy", create_test = true },

            { location = "eu", env = "stg", scope = "deploy", create_test = true },

            { location = "us", env = "prod", scope = "deploy", create_test = true },

            { location = "eu", env = "prod", scope = "deploy", create_test = true },

            { location = "au", env = "prod", scope = "deploy", create_test = true },

          ] 

        },



        {

          name      = "POWERBI_FEATURE_ID"

          type      = "static"

          value     = "T678faae9-12e5-47ae-89da-2ed41bee8b9fvizpbi"

          regions_envs = [

            { location = "us", env = "prod", scope = "deploy", create_test = true },

          ] 

        },



      ] 

    }

  }

}



variable "watchdog_monitors" {

  description = "List of Watchdog monitors"

  type = map(any)

  default = {

    team_1 = {

      team_name = "TEAM_NAME_3"

      monitors = [

        {

          name = "Watchdog monitors for Sea Lions"

          notify = "@teams-Sea_Lions_Prod_Alerts_Channel"

          priority = 4

          tag_ciid = {

            global = ""

            us     = ""

            au     = ""

            eu     = ""

            sg     = ""

          }

          story_category = [

            "apm",

            "logs"

          ]

          services = [

            "wb-mydata-api",

            "workbench-ng-analytics",

            "workbench-ng-app-configuration",

            "workbench-ng-authorization",

            "workbench-ng-content",

            "workbench-ng-gallery",

            "workbench-ng-microfrontends",

            "workbench-ng-pages",

            "workbench-ng-sites",

            "workbench-ng-user-directory",

            "workbench-ng-workspace-context-adapter"

          ]

          envs = [

            "us-dev-deploy",

            "us-qa-deploy",

            "us-stage-deploy",

            "eu-stage-deploy",

            "us-prod-deploy",

            "eu-prod-deploy",

            "au-prod-green",

            "sg-prod-deploy"

          ]

        }

      ]

    }

  }

}



variable "paas_monitors" {

  default = {

    team_1 = {

      team_name = "TEAM_NAME_1"

      paas = [

        {

          service = "mysql"

          subscription_name = [

            "pzi-gxeu-p-sub162",

            "pzi-gxus-p-sub312"

          ]

          monitors = [

            {

              alert_name = "MYSQL-PAAS SQL Server Count Exceeds Threshold"

              query = "avg(last_10m):sum:azure.sql_servers.count{subscription_name: <subscription_name>} by {region} > 200"

              message = "SQL Server Count in {{region}} Exceeds defined Threshold"

              critical = 200

              critical_recovery = null

              warning           = null

              warning_recovery  = null

              priority          = 3

              notify = "@teams-Orca_Prod_Alerts_Channel"

              create_monitor = true

            },

            {

              alert_name = "MYSQL-PAAS SQL Database per server Count Exceeds Threshold"

              query = "avg(last_10m):sum:azure.sql_servers_databases.count{subscription_name: <subscription_name>} by {region} > 4000"

              message = "SQL Database per server Count in {{region}} Exceeds defined Threshold"

              critical = 4000

              critical_recovery = null

              warning           = null

              warning_recovery  = null

              priority          = 3

              notify = "@teams-Orca_Prod_Alerts_Channel"

              create_monitor = true

            }

          ]

        },

        {

          service = "couchbase"

          couchbase_env = [

            "us-stage-deploy", 

            "eu-stage-deploy", 

            "us-prod-deploy", 

            "eu-prod-deploy",

            "sg-prod-deploy",

            "au-prod-green"

          ]

          monitors = [

            {

              alert_name = "Vizinsights connection to Couchbase - High Error Rate"

              query = "sum(last_10m):(sum:trace.couchbase.call.errors{env:<couchbase_env> , peer.db.system:couchbase , base_service:vizinsights}.as_count() / sum:trace.couchbase.call.hits{env:<couchbase_env> , peer.db.system:couchbase , base_service:vizinsights}.as_count()) > 0.25"

              message = "Vizinsights connection to Couchbase error rate is too high in {{env}}"

              critical = 0.25

              critical_recovery = 0.20

              warning           = null

              warning_recovery  = null

              priority          = 3

              notify = "@teams-Orca_Prod_Alerts_Channel"

              create_monitor = true

            }

          ]

        }  

      ]

    },

    team_2 = {

      team_name = "TEAM_NAME_7"

      paas = [

        {

          service = "eventhub"

          eh-name = [

            ##"pzi-gxus-n-ehb-evhb-s001",

            ##"pzi-gxeu-g-ehb-evhb-s001,

            "pzi-gxau-p-ehb-evhb-p001",

            "pzi-gxeu-p-ehb-evhb-p001",

            "pzi-gxus-p-ehb-evhb-p001",

            "sg-prod-platform-eventhub-ns-001"

          ]

          monitors = [

            {

              alert_name = "EVENTHUB-PAAS User Errors Count Exceeds Threshold"

              query = "avg(last_10m):sum:azure.eventhub_namespaces.user_errors.count{name:<eh-name>} > 3"

              message = "{{name}} Event hub user errors exceeds defined threshold. Subscription: {{subscription_name}}"

              critical = 3

              critical_recovery = 2

              warning           = null

              warning_recovery  = null

              priority          = 3

              notify = "@pagerduty-DD_DataPlatform_SRE"

              create_monitor = true

            },

            {

              alert_name = "EVENTHUB-PAAS Server Errors Count Exceeds Threshold"

              query = "avg(last_10m):sum:azure.eventhub_namespaces.server_errors.count{name:<eh-name>} > 3"

              message = "{{name}} Event hub server errors exceeds defined threshold. Subscription: {{subscription_name}}"

              critical = 3

              critical_recovery = 2

              warning           = null

              warning_recovery  = null

              priority          = 3

              notify = "@pagerduty-DD_DataPlatform_SRE"

              create_monitor = true

            },

            {

              alert_name = "EVENTHUB-PAAS Server Quota Exceeded Errors Count Exceeds Threshold"

              query = "avg(last_10m):sum:azure.eventhub_clusters.quota_exceeded_errors.count{name:<eh-name>} > 2"

              message = "{{name}} Event hub quota exceeded errors exceeds defined threshold. Subscription: {{subscription_name}}"

              critical = 2

              critical_recovery = 1

              warning           = null

              warning_recovery  = null

              priority          = 3

              notify = "@pagerduty-DD_DataPlatform_SRE"

              create_monitor = true

            },

            {

              alert_name = "EVENTHUB-PAAS Throttled Requests Count Exceeds Threshold"

              query = "avg(last_10m):sum:azure.eventhub_namespaces.throttled_requests.count{name:<eh-name>} > 3"

              message = "{{name}} Event hub throttled requests exceeds defined threshold. Subscription: {{subscription_name}}"

              critical = 3

              critical_recovery = 2

              warning           = null

              warning_recovery  = null

              priority          = 3

              notify = "@pagerduty-DD_DataPlatform_SRE"

              create_monitor = true

            }

          ]

        },

        {

          service = "cosmosdb"

          cosmosdb-name = [

            "pzi-gxus-n-cdb-csms-s002", #US-STG

            "pzi-gxeu-g-cdb-csms-s001", #EU-STG

            "pzi-gxus-p-cdb-csms-p002", #US-PROD

            "pzi-gxeu-p-cdb-csms-p001", #EU-PROD

            "pzi-gxau-p-cdb-csms-p001", #AU-PROD

            "sgprodcsmsstrd001"         #SG-PROD

          ]

          monitors = [

            {

              alert_name = "COSMOSDB-PAAS High Error Rate Exceeds Threshold"

              query = "sum(last_10m):(sum:azure.cosmosdb.total_requests{name:<cosmosdb-name> , ! statuscode:200 , ! statuscode:201, !statuscode:204} by {collectionname}.as_count() / sum:azure.cosmosdb.total_requests{name:<cosmosdb-name>} by {collectionname}.as_count()) > 0.05"

              message = "{{name}} High Error rate exceeds defined threshold. Subscription: {{subscription_name}}"

              critical = 0.05

              critical_recovery = 0.03

              warning           = null

              warning_recovery  = null

              priority          = 3

              notify = "@pagerduty-DD_DataPlatform_SRE"

              create_monitor = true

            }

          ]

        }

      ]

    },

    team_3 = {

      team_name = "TEAM_NAME_4"

      paas = [

        {

          service = "adf"

          subscription_name = [

            "pzi-gxeu-p-sub161",

            "pzi-gxus-p-sub313"

          ]

          monitors = [

            {

              alert_name = "ADF-PAAS Instances Exceeds Threshold"

              query = "avg(last_10m):sum:azure.datafactory_factories.count{subscription_name: <subscription_name>} by {region} > 640"

              message = "ADF Instances Count in {{region}} Exceeds defined Threshold"

              critical = 640

              critical_recovery = null

              warning           = null

              warning_recovery  = null

              priority          = 3

              notify = ""

              create_monitor = true

            }

          ]

        },

        {

          service = "virtual network"

          subscription_name = [

            "pzi-gxeu-p-sub161",

            "pzi-gxus-p-sub313"

          ]

          monitors = [

            {

              alert_name = "[ADF]Virtual Network-Total Used IP Count Exceeds Threshold"

              # query = "avg(last_10m):sum:azure.network_virtualnetworks.allocated_addresses{subscription_name: <subscription_name>} by {region} > 819"

              query = "avg(last_10m):((sum:azure.network_virtualnetworks.allocated_addresses{subscription_name: <subscription_name>} by {region}) / (sum:azure.network_virtualnetworks.total_addresses{subscription_name: <subscription_name>} by {region})) * 100 > 65"              

              message = "[ADF]Total Used IP Count in {{region}} Exceeds defined Threshold"

              critical = 65

              critical_recovery = null

              warning           = null

              warning_recovery  = null

              priority          = 2

              notify = ""

              create_monitor = true

            }

          ]

        },

        {

          service = "virtual network"

          subscription_name = [

            "pzi-gxeu-p-sub162",

            "pzi-gxus-p-sub312"

          ]

          monitors = [

            {

              alert_name = "[SQL]Virtual Network-Total Used IP Count Exceeds Threshold"

              # query = "avg(last_10m):sum:azure.network_virtualnetworks.allocated_addresses{subscription_name: <subscription_name>} by {region} > 818"

              query = "avg(last_10m):((sum:azure.network_virtualnetworks.allocated_addresses{subscription_name: <subscription_name>} by {region}) / (sum:azure.network_virtualnetworks.total_addresses{subscription_name: <subscription_name>} by {region})) * 100 > 65"              

              message = "[SQL]Total Used IP Count in {{region}} Exceeds defined Threshold"

              critical = 65

              critical_recovery = null

              warning           = null

              warning_recovery  = null

              priority          = 2

              notify = ""

              create_monitor = true

            }

          ]

        }        

      ]

    },

  }

}








