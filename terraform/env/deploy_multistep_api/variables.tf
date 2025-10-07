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