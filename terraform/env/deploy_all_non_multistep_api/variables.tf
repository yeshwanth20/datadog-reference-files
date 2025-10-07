variable "default_tags" {
  default = [
    "value_stream:data_platform",
    "managed_by:terraform",
  ]
}

variable "default_tags_synthetic_ssl" {
  default = [
    "pwc_severity:3",
    "pwc_target_persona:business,product_owner",
  ]
}

variable "default_tags_kube_cluster" {
  default = [
    "pwc_integration:splunk",
    "pwc_severity:3",
    "service:kubernetes",
  ]
}

variable "team_names" {
  default = {
    TEAM_NAME_1 = "Orca",
    TEAM_NAME_2 = "Blue_Whales",
    TEAM_NAME_3 = "Sea_Lions",
    TEAM_NAME_4 = "Dolphins",
    TEAM_NAME_6 = "Captain_America",
  }
}

#kube_monitors variable defines a list of monitoring alerts for Kubernetes clusters.
#Each object in the list specifies the conditions for triggering a metric alert and the message to be sent when triggered.
#The alerts include checks for pods being restarted too often, unschedulable nodes, failed pods, replicas being down, and pods being in a state of ImagePullBackOff or CrashloopBackOff.

variable "team_kube_monitors" {
  type = any
  default = {
      team_1 = {
        team_name = "TEAM_NAME_2"
        metrics_type = [
          {
            metrics_name = "service"
            metrics_detail = [
              {
                tag_ciid = {
                    global = ""
                    us     = ""
                    au     = ""
                    eu     = ""
                    sg     = ""
                }
                alert_name        = "Kubernetes Memory Usage above threshold"
                critical          = 0.8
                critical_recovery = 0.7
                message           = "Kubernetes Memory Usage above threshold 80, memory is almost full. {{kube_namespace.name}} {{kube_cluster_name}}"
                recovery_message = " Kubernetes Memory Usage above threshold recovered "
                notify = " "
                #priority          = 3
                mon_priority      = {}
                namespace         = null
                query             = "avg(last_15m):avg:kubernetes.memory.usage_pct{kube_namespace:default AND (kube_deployment:ldap-admin-service OR kube_deployment:directory-service OR kube_deployment:fabric-api-v3 OR kube_deployment:workspace-exp OR kube_deployment:workspace-exp OR kube_deployment:ms-teams-wrapper OR kube_deployment:workspace-asset-mgmt OR kube_deployment:azure-storage-service OR kube_deployment:engagement-service-v2 OR kube_deployment:django-engagement-admin)} by {kube_cluster_name} > 0.8"
              },

              {
                  tag_ciid = {
                    global = ""
                    us     = ""
                    au     = ""
                    eu     = ""
                    sg     = ""
                }
                alert_name        = "Deployments Replica Pods"
                critical          = 1
                critical_recovery = 0.9
                message           = "More than one Deployments Replica's pods are down in Deployment {{kube_namespace.name}}/{{kube_deployment.name}}."
                recovery_message = " Deployments Replica Pods recovered "
                notify = " "
                #priority          = 3
                mon_priority      = {}
                namespace         = null
                query             = "avg(last_15m):avg:kubernetes_state.deployment.replicas_desired{kube_namespace:default AND (kube_deployment:ldap-admin-service OR kube_deployment:directory-service OR kube_deployment:fabric-api-v3 OR kube_deployment:workspace-exp OR kube_deployment:workspace-exp OR kube_deployment:ms-teams-wrapper OR kube_deployment:workspace-asset-mgmt OR kube_deployment:azure-storage-service OR kube_deployment:engagement-service-v2 OR kube_deployment:django-engagement-admin )} by {kube_namespace,kube_deployment} - avg:kubernetes_state.deployment.replicas_available{kube_namespace:default AND (kube_deployment:ldap-admin-service OR kube_deployment:directory-service OR kube_deployment:fabric-api-v3 OR kube_deployment:workspace-exp OR kube_deployment:workspace-exp OR kube_deployment:ms-teams-wrapper OR kube_deployment:workspace-asset-mgmt OR kube_deployment:azure-storage-service OR kube_deployment:engagement-service-v2 OR kube_deployment:django-engagement-admin )} by {kube_namespace,kube_deployment} >= 1"
              },
            ]
          },            
          {
            metrics_name = "nifi"
            metrics_detail = [
              {
                tag_ciid = {
                    global = ""
                    us     = ""
                    au     = ""
                    eu     = ""
                    sg     = ""
                }                 
              
                  alert_name        = "Statefulset Replicas"
                  type              = "metric alert"
                  critical          = 2
                  critical_recovery = 1
                  message           = "More than one Statefulset Replica's pods are down in Statefulset {{kube_namespace.name}}/{{kube_stateful_set.name}}. This might present an unsafe situation for any further manual operations, such as killing other pods."
                  recovery_message = "Statefulset Replicas recovered."
                  notify = " "
                  #priority          = 3
                  mon_priority      = {}
                  query             = "max(last_15m):sum:kubernetes_state.statefulset.replicas_desired{kube_cluster_name:default AND (kube_namespace:aad-management* Or kube_namespace:workspace-migration* Or kube_namespace:workspace-management* Or kube_namespace:aad-hygiene* )} by {kube_namespace,kube_stateful_set} - sum:kubernetes_state.statefulset.replicas_ready{kube_cluster_name:default AND (kube_namespace:aad-management* Or kube_namespace:workspace-migration* Or kube_namespace:workspace-management* Or kube_namespace:aad-hygiene* )} by {kube_namespace,kube_stateful_set} >= 2"
              }   
            ]
          }
        ]
      },
    team_2 = {
      team_name = "TEAM_NAME_4"
      metrics_type = [
        {
          metrics_name = "service"
          metrics_detail = [
            {
                tag_ciid = {
                  global = ""
                  us     = ""
                  au     = ""
                  eu     = ""
                  sg     = ""
              }
              alert_name        = "Kubernetes Memory Usage above threshold"
              critical          = 0.8
              critical_recovery = 0.7
              message           = "Kubernetes Memory Usage above threshold 80, memory is almost full. {{kube_namespace.name}} {{kube_cluster_name}}"
              recovery_message = " Kubernetes Memory Usage above threshold recovered "
              notify = " "
              #priority          = 3
              mon_priority      = {}
              namespace         = null
              query             = "avg(last_15m):avg:kubernetes.memory.usage_pct{kube_namespace:default AND (kube_deployment:workbench-service* OR kube_deployment:service-definitions OR kube_deployment:authz OR kube_deployment:autz-service OR kube_deployment:kv-store OR kube_deployment:preference-service* OR kube_deployment:dp-approval-service OR kube_deployment:directory-service OR kube_deployment:dp-idbroker OR kube_deployment:wbservices-api OR kube_deployment: alteryx-macros)} by {kube_cluster_name} > 0.8"
            },
            {
              tag_ciid = {
                global = ""
                us     = ""
                au     = ""
                eu     = ""
                sg     = ""
              }
              alert_name        = "Pod restart in cluster greater than 3"
              critical          = 3
              critical_recovery = 2
              message           = "{{kube_deployment.name}} {{pod_name.name}} {{kube_cluster_name.name}}. cluster pod is restarted more than >= {{threshold}} "
              recovery_message = "{{kube_deployment.name}} {{pod_name.name}} {{kube_cluster_name.name}} cluster pod restarted Alert Solved."
              notify = " "
              #priority          = 3
              mon_priority      = {}
              namespace         = null
              query = "events(\"source:kubernetes AND restarting AND kube_namespace:default AND pod_name:(workbench-service* OR service-definitions* OR authz* OR autz-service* OR kv-store* OR preference-service* OR dp-approval-service* OR directory-service* OR dp-idbroker* OR wbservices-api* OR  alteryx-macros*)\").rollup(\"cardinality\", \"pod_name\").by(\"pod_name,kube_cluster_name\").last(\"15m\") >= 3"
            },
            {
            tag_ciid = {
                global = ""
                us     = ""
                au     = ""
                eu     = ""
                sg     = ""
            }
            alert_name        = "Deployments Replica Pods"
            critical          = 2
            critical_recovery = 1
            message           = "More than one Deployments Replica's pods are down in Deployment {{kube_namespace.name}}/{{kube_deployment.name}}."
            recovery_message = " Deployments Replica Pods recovered "
            notify = " "
            #priority          = 3
            mon_priority      = {}
            namespace         = null
            query             = "avg(last_15m):avg:kubernetes_state.deployment.replicas_desired{kube_namespace:default AND (kube_deployment:workbench-service* OR kube_deployment:service-definitions OR kube_deployment:authz OR kube_deployment:autz-service OR kube_deployment:kv-store OR kube_deployment:preference-service* OR kube_deployment:dp-approval-service OR kube_deployment:directory-service OR kube_deployment:dp-idbroker OR kube_deployment:wbservices-api OR kube_deployment: alteryx-macros) } by {kube_namespace,kube_deployment} - avg:kubernetes_state.deployment.replicas_available{kube_namespace:default AND (kube_deployment:workbench-service* OR kube_deployment:service-definitions OR kube_deployment:authz OR kube_deployment:autz-service OR kube_deployment:kv-store OR kube_deployment:preference-service* OR kube_deployment:dp-approval-service OR kube_deployment:directory-service OR kube_deployment:dp-idbroker OR kube_deployment:wbservices-api OR kube_deployment: alteryx-macros)} by {kube_namespace,kube_deployment} >= 2"

            },
            {
              tag_ciid = {
                global = ""
                us     = ""
                au     = ""
                eu     = ""
                sg     = ""
              }
              alert_name        = "Dcam-Api Kubernetes Memory Usage above threshold"
              critical          = 0.8
              critical_recovery = 0.7
              message           = "Dcam-Api pod memory usage above 80% threshold. {{kube_namespace.name}} {{kube_cluster_name}}"
              recovery_message  = "Dcam-Api pod memory usage has recovered below threshold."              
              notify = " "
              #priority          = 3
              mon_priority      = {}
              namespace         = null
              query             = "max(last_15m):max:kubernetes.memory.usage_pct{kube_deployment:dcam-api AND (kube_namespace:dp-services-us-prod OR kube_namespace:dp-services-eu-prod OR kube_namespace:dataplatform-au-prod OR kube_namespace:dp-services-sg-prod)} by {pod_name} > 0.8"
            }                      
          ]
        },
      ]
    },
    
    team_3 = {
      team_name = "TEAM_NAME_3"
      metrics_type = [
        {
          metrics_name = "service"
          metrics_detail = [
            {
              tag_ciid = {
                global = ""
                us     = ""
                au     = ""
                eu     = ""
                sg     = ""
              }
              alert_name        = "Kubernetes Memory Usage above threshold"
              critical          = 0.8
              critical_recovery = 0.7
              message           = "Kubernetes Memory Usage above threshold 80, memory is almost full. {{kube_namespace.name}} {{kube_cluster_name}}"
              recovery_message = " Kubernetes Memory Usage above threshold recovered "
              notify = " "
              notify_non_prod   = "@teams-Sea_Lions_Non_Prod_Alerts_Channel"
              notify_prod       = "@teams-Sea_Lions_Prod_Alerts_Channel"
              #priority          = 3
              mon_priority      = {}
              namespace = {
                dev = ""
                qa  = ""
                us_stg = "dp-mfe-us-stage"
                eu_stg = "dp-mfe-eu-stage"
                us_prod = "dp-mfe-us-prod"
                eu_prod = "dp-mfe-eu-prod"
                au_prod = "dp-mfe-au-prod"
                sg_prod = "dp-mfe-sg-prod"
              }
              query             = "avg(last_15m):avg:kubernetes.memory.usage_pct{ kube_namespace:default AND (kube_deployment: workbench-ng-analytics OR kube_deployment: workbench-ng-app-configuration OR kube_deployment: workbench-ng-authorization OR kube_deployment: workbench-ng-content OR kube_deployment: workbench-ng-gallery OR kube_deployment: workbench-ng-microfrontends OR kube_deployment: workbench-ng-pages OR kube_deployment: workbench-ng-sites OR kube_deployment: workbench-ng-user-directory OR kube_deployment: workbench-ng-workspace-context-adapter OR kube_deployment: wb-mydata-api )} by {kube_cluster_name} > 0.8"
            },
            {
              tag_ciid = {
                global = ""
                us     = ""
                au     = ""
                eu     = ""
                sg     = ""
              }
              alert_name        = "Pod restart in cluster greater than 3"
              critical          = 3
              critical_recovery = 2
              message           = "{{kube_deployment.name}} {{pod_name.name}} {{kube_cluster_name.name}}. cluster pod is restarted more than >= {{threshold}} "
              recovery_message = "{{kube_deployment.name}} {{pod_name.name}} {{kube_cluster_name.name}} cluster pod restarted Alert Solved."
              notify = " "
              notify_non_prod   = "@teams-Sea_Lions_Non_Prod_Alerts_Channel"
              notify_prod       = "@teams-Sea_Lions_Prod_Alerts_Channel"
              #priority          = 3
              mon_priority      = {}
              namespace = {   
                dev = ""
                qa  = ""
                us_stg = "dp-mfe-us-stage"
                eu_stg = "dp-mfe-eu-stage"
                us_prod = "dp-mfe-us-prod"
                eu_prod = "dp-mfe-eu-prod"
                au_prod = "dp-mfe-au-prod"
                sg_prod = "dp-mfe-sg-prod"
              }
              query = "events(\"source:kubernetes AND restarting AND kube_namespace:default AND pod_name:(workbench-ng-analytics* OR workbench-ng-app-configuration* OR workbench-ng-authorization* OR workbench-ng-content* OR workbench-ng-gallery* OR workbench-ng-microfrontends* OR workbench-ng-pages* OR workbench-ng-sites* OR workbench-ng-user-directory* OR workbench-ng-workspace-context-adapter* OR wb-mydata-api*)\").rollup(\"cardinality\", \"pod_name\").by(\"pod_name,kube_cluster_name\").last(\"15m\") >= 3"
            },
            {
              tag_ciid = {
                global = ""
                us     = ""
                au     = ""
                eu     = ""
                sg     = ""
              }
              alert_name        = "Deployments Replica Pods"
              critical          = 2
              critical_recovery = 1
              message           = "More than one Deployments Replica's pods are down in Deployment {{kube_namespace.name}}/{{kube_deployment.name}}."
              recovery_message = " Deployments Replica Pods recovered "
              notify = " "
              notify_non_prod   = "@teams-Sea_Lions_Non_Prod_Alerts_Channel"
              notify_prod       = "@teams-Sea_Lions_Prod_Alerts_Channel"
              #priority          = 3
              mon_priority      = {}
              namespace = {   
                dev = ""
                qa  = ""
                us_stg = "dp-mfe-us-stage"
                eu_stg = "dp-mfe-eu-stage"
                us_prod = "dp-mfe-us-prod"
                eu_prod = "dp-mfe-eu-prod"
                au_prod = "dp-mfe-au-prod"
                sg_prod = "dp-mfe-sg-prod"
              }
              query             = "avg(last_15m):avg:kubernetes_state.deployment.replicas_desired{ kube_namespace:default AND (kube_deployment: workbench-ng-analytics OR kube_deployment: workbench-ng-app-configuration OR kube_deployment: workbench-ng-authorization OR kube_deployment: workbench-ng-content OR kube_deployment: workbench-ng-gallery OR kube_deployment: workbench-ng-microfrontends OR kube_deployment: workbench-ng-pages OR kube_deployment: workbench-ng-sites OR kube_deployment: workbench-ng-user-directory OR kube_deployment: workbench-ng-workspace-context-adapter OR kube_deployment: wb-mydata-api ) } by {kube_namespace,kube_deployment} - avg:kubernetes_state.deployment.replicas_available{ kube_namespace:default AND (kube_deployment: workbench-ng-analytics OR kube_deployment: workbench-ng-app-configuration OR kube_deployment: workbench-ng-authorization OR kube_deployment: workbench-ng-content OR kube_deployment: workbench-ng-gallery OR kube_deployment: workbench-ng-microfrontends OR kube_deployment: workbench-ng-pages OR kube_deployment: workbench-ng-sites OR kube_deployment: workbench-ng-user-directory OR kube_deployment: workbench-ng-workspace-context-adapter OR kube_deployment: wb-mydata-api )} by {kube_namespace,kube_deployment} >= 2"
            },
          ]
        },
      ]
    },

    team_4 = {
      team_name = "TEAM_NAME_6"
      metrics_type = [
        {
          metrics_name = "service"
          metrics_detail = [
            {
              tag_ciid = {
                global = ""
                us     = ""
                au     = ""
                eu     = ""
                sg     = ""
              }
              alert_name        = "Kubernetes Memory Usage above threshold"
              critical          = 0.8
              critical_recovery = 0.7
              message           = "Kubernetes Memory Usage above threshold 80, memory is almost full. {{kube_namespace.name}} {{kube_cluster_name}}"
              recovery_message = " Kubernetes Memory Usage above threshold recovered "
              notify = " "
              #priority          = 3
              mon_priority      = {}
              namespace         = null
              query             = "avg(last_15m):avg:kubernetes.memory.usage_pct{kube_namespace:default AND (kube_deployment:catalogue-service-v3 OR kube_deployment:workspace-asset-mgmt* OR kube_deployment:catalogue-service OR kube_deployment:ldap-admin-service OR kube_deployment:adf-service OR kube_deployment:data-access-mgmt* OR kube_deployment:service-provisioning-api )} by {kube_cluster_name} > 0.8"
            },
            {
              tag_ciid = {
                global = ""
                us     = ""
                au     = ""
                eu     = ""
                sg     = ""
              }
              alert_name        = "Pod restart in cluster greater than 3"
              critical          = 3
              critical_recovery = 2
              message           = "{{kube_deployment.name}} {{pod_name.name}} {{kube_cluster_name.name}}. cluster pod is restarted more than >= {{threshold}} "
              recovery_message = "{{kube_deployment.name}} {{pod_name.name}} {{kube_cluster_name.name}} cluster pod restarted Alert Solved."
              notify = " "
              #priority          = 3
              mon_priority      = {}
              namespace         = null
              query = "events(\"source:kubernetes AND restarting AND kube_namespace:default AND pod_name:(catalogue-service-v3* OR workspace-asset-mgmt* OR catalogue-service* OR ldap-admin-service* OR adf-service* OR data-access-mgmt* OR service-provisioning-api* )\").rollup(\"cardinality\", \"pod_name\").by(\"pod_name,kube_cluster_name\").last(\"15m\") >= 3"
            },
            {
              tag_ciid = {
                  global = ""
                  us     = ""
                  au     = ""
                  eu     = ""
                  sg     = ""
              }
              alert_name        = "Deployments Replica Pods"
              critical          = 2
              critical_recovery = 1
              message           = "More than one Deployments Replica's pods are down in Deployment {{kube_namespace.name}}/{{kube_deployment.name}}."
              recovery_message = " Deployments Replica Pods recovered "
              notify = " "
              #priority          = 3
              mon_priority      = {}
              namespace         = null
              query             = "avg(last_15m):avg:kubernetes_state.deployment.replicas_desired{kube_namespace:default AND (kube_deployment:catalogue-service-v3 OR kube_deployment:workspace-asset-mgmt* OR kube_deployment:catalogue-service OR kube_deployment:ldap-admin-service OR kube_deployment:adf-service OR kube_deployment:data-access-mgmt* OR kube_deployment:service-provisioning-api ) } by {kube_namespace,kube_deployment} - avg:kubernetes_state.deployment.replicas_available{kube_namespace:default AND (kube_deployment:catalogue-service-v3 OR kube_deployment:workspace-asset-mgmt* OR kube_deployment:catalogue-service OR kube_deployment:ldap-admin-service OR kube_deployment:adf-service OR kube_deployment:data-access-mgmt* OR kube_deployment:service-provisioning-api )} by {kube_namespace,kube_deployment} >= 2"

            },

          ]
        },
      ],
    },

    team_5 = {
          team_name = "TEAM_NAME_1"
          metrics_type = [
            {
              metrics_name = "service"
              metrics_detail = [
              {
                tag_ciid = {
                    global = ""
                    us     = ""
                    au     = ""
                    eu     = ""
                    sg     = ""
                }
                alert_name        = "Kubernetes Memory Usage above threshold"
                critical          = 0.8
                critical_recovery = 0.7
                message           = "Kubernetes Memory Usage above threshold 80, memory is almost full. {{kube_namespace.name}} {{kube_cluster_name}}"
                recovery_message = " Kubernetes Memory Usage above threshold recovered "
                notify = " "
                #priority          = 3
                mon_priority      = {}
                namespace         = null
                query             = "avg(last_15m):avg:kubernetes.memory.usage_pct{kube_namespace:default AND (kube_deployment:vizinsights OR kube_deployment:viz-cmd-api OR kube_deployment:viz-query-api OR kube_deployment:viz-asset-handler OR kube_deployment:viz-management-api OR kube_deployment:viz-activity-handler OR kube_deployment:viz-event-store-feed OR kube_deployment:viz-workspace-handler OR kube_deployment:viz-notification-handler OR kube_deployment:viz-event-store-feed OR kube_deployment:tableau-service OR kube_deployment:powerbi-service OR kube_deployment:kube-utility-service)} by {kube_cluster_name} > 0.8"
              },
              {
                tag_ciid = {
                  global = ""
                  us     = ""
                  au     = ""
                  eu     = ""
                  sg     = ""
                }
                alert_name        = "Pod restart in cluster greater than 3"
                critical          = 3
                critical_recovery = 2
                message           = "{{kube_deployment.name}} {{pod_name.name}} {{kube_cluster_name.name}}. cluster pod is restarted more than >= {{threshold}} "
                recovery_message = "{{kube_deployment.name}} {{pod_name.name}} {{kube_cluster_name.name}} cluster pod restarted Alert Solved."
                notify = " "
                #priority          = 3
                mon_priority      = {}
                namespace         = null
                query = "events(\"source:kubernetes AND restarting AND kube_namespace:default AND pod_name:(vizinsights* OR viz-cmd-api* OR viz-query-api* OR viz-asset-handler* OR viz-management-api* OR viz-activity-handler* OR viz-event-store-feed* OR viz-workspace-handler* OR viz-notification-handler* OR viz-event-store-feed* OR tableau-service* OR powerbi-service* OR kube-utility-service*)\").rollup(\"cardinality\", \"pod_name\").by(\"pod_name,kube_cluster_name\").last(\"15m\") >= 3"
              },
              {
                tag_ciid = {
                    global = ""
                    us     = ""
                    au     = ""
                    eu     = ""
                    sg     = ""
                }
                alert_name        = "Deployments Replica Pods"
                critical          = 2
                critical_recovery = 1
                message           = "More than one Deployments Replica's pods are down in Deployment {{kube_namespace.name}}/{{kube_deployment.name}}."
                recovery_message = " Deployments Replica Pods recovered "
                notify = " "
                #priority          = 3
                mon_priority      = {}
                namespace         = null
                query             = "avg(last_15m):avg:kubernetes_state.deployment.replicas_desired{kube_namespace:default AND (kube_deployment:vizinsights OR kube_deployment:viz-cmd-api OR kube_deployment:viz-query-api OR kube_deployment:viz-asset-handler OR kube_deployment:viz-management-api OR kube_deployment:viz-activity-handler OR kube_deployment:viz-event-store-feed OR kube_deployment:viz-workspace-handler OR kube_deployment:viz-notification-handler OR kube_deployment:viz-event-store-feed OR kube_deployment:tableau-service OR kube_deployment:powerbi-service OR kube_deployment:kube-utility-service)} by {kube_namespace,kube_deployment} - avg:kubernetes_state.deployment.replicas_available{kube_namespace:default AND (kube_deployment:vizinsights OR kube_deployment:viz-cmd-api OR kube_deployment:viz-query-api OR kube_deployment:viz-asset-handler OR kube_deployment:viz-management-api OR kube_deployment:viz-activity-handler OR kube_deployment:viz-event-store-feed OR kube_deployment:viz-workspace-handler OR kube_deployment:viz-notification-handler OR kube_deployment:viz-event-store-feed OR kube_deployment:tableau-service OR kube_deployment:powerbi-service OR kube_deployment:kube-utility-service)} by {kube_namespace,kube_deployment} >= 2"

              },

              ],
            },
          ]
    },

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
    # priority           = 3
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
    priority           = 2
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
    tick_interval      = 259200 # Ping time interval
    test_port          = 443
    # priority           = 3
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
    tick_interval      = 259200 # Ping time interval
    priority           = 3
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

variable "teams" {
  description = "List of health monitors for all teams and their services"
  type       =  map(any)
  default = {
    team_1 = {
      team_name = "TEAM_NAME_1"
      services = [
        {
          name        = "django-engagement-admin"
          trace       = "django"
          set_we_tag  = false
          service_name = null
          notify_non_prod = "@teams-Orca_Non_Prod_Alerts_Channel"
          notify_prod = "@teams-Orca_Prod_Alerts_Channel"
          notify_her_monitors = ""
          tag_ciid = {
            us = "CI116457299"
            au = "CI116457301"
            eu = "CI116457303"
            sg = "CI116457305"
          }
          synthetic_test_url_prefix  = "django-engagement-admin"
          synthetics_mon_priority   = {}
          synthetic_test = []
          synthetic_oauth_login_test = []
          critical_alerts = [
            {
              high_error_rate = [
                "get_api/v1/engagement/"
              ]
              query = "sum(last_5m):(sum:trace.django.request.errors{env:##ENV##,service:django-engagement-admin,resource_name:get_api/v1/engagement/ }.as_count() / sum:trace.django.request.hits{env:##ENV##,service:django-engagement-admin,resource_name:get_api/v1/engagement/ }.as_count()) > 1"
              critical_threshold = {
                dev = "1", qa = "1", uat = "1", us_stg = "1", eu_stg = "1", us_prod = "1", eu_prod = "1", au_prod = "1", sg_prod = "1"
              }
              mon_priority = {}
            },
            {
              high_error_rate = [
                "get_api/v1/engagement/_p_pk_/._/"
              ]
              query = "sum(last_5m):(sum:trace.django.request.errors{env:##ENV##,service:django-engagement-admin,resource_name:get_api/v1/engagement/_p_pk_/._/}.as_count() / sum:trace.django.request.hits{env:##ENV##,service:django-engagement-admin,resource_name:get_api/v1/engagement/_p_pk_/._/}.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            },
            {
              high_error_rate = [
                "get_api/v1/users"
              ]
              query = "sum(last_5m):(sum:trace.django.request.errors{env:##ENV##,service:django-engagement-admin,resource_name:get_api/v1/users }.as_count() / sum:trace.django.request.hits{env:##ENV##,service:django-engagement-admin,resource_name:get_api/v1/users }.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            },
            {
              high_error_rate = [
                "post_api/rbac/v1/check"
              ]
              query = "sum(last_5m):(sum:trace.django.request.errors{env:##ENV##,service:django-engagement-admin,resource_name:post_api/rbac/v1/check }.as_count() / sum:trace.django.request.hits{env:##ENV##,service:django-engagement-admin,resource_name:post_api/rbac/v1/check }.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            },
            {
              high_error_rate = [
                "get_api/v4/feature-switch/user/_p_pwc_guid_0-9a-za-z_-"
              ]
              query = "sum(last_5m):(sum:trace.django.request.errors{env:##ENV##,service:django-engagement-admin,resource_name:get_api/v4/feature-switch/user/_p_pwc_guid_0-9a-za-z_- }.as_count() / sum:trace.django.request.hits{env:##ENV##,service:django-engagement-admin,resource_name:get_api/v4/feature-switch/user/_p_pwc_guid_0-9a-za-z_- }.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            },

          ]
        },
        {
          name        = "Power BI"
          trace       = "servlet"
          set_we_tag  = false
          service_name = null
          notify_non_prod = "@teams-Orca_Non_Prod_Alerts_Channel"
          notify_prod = "@teams-Orca_Prod_Alerts_Channel"
          notify_her_monitors = ""
          tag_ciid = {
            us = "CI58685180"
            au = "CI58685184"
            eu = "CI58685186"
            sg = "CI58685188"
          }
          synthetic_test_url_prefix = "powerbi-service"
          synthetics_mon_priority   = {}
          synthetic_test = [
            {
              url_suffix = "-pwclabs.pwcglb.com/api/v1/actuator/health"
              type       = "health"
            },
            {
              url_suffix = "-pwclabs.pwcglb.com"
              type       = "ssl"
            }
          ]
          synthetic_oauth_login_test = []
          critical_alerts = [
            {
              high_error_rate = [
                "get_/groups/_groupid_/dashboards",
                "get_/groups/_groupid_/reports",
                "get_/groups/_groupid_/users",
              ]
              query = null
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            }
          ]          
        },
        {
          name        = "Tableau"
          trace       = "servlet"
          set_we_tag  = false
          service_name = null
          notify_non_prod = "@teams-Orca_Non_Prod_Alerts_Channel"
          notify_prod = "@teams-Orca_Prod_Alerts_Channel"
          notify_her_monitors = ""
          tag_ciid = {
            us = "CI58685180"
            au = "CI58685184"
            eu = "CI58685186"
            sg = "CI58685188"
          }
          synthetic_test_url_prefix = "tableau-service"
          synthetics_mon_priority   = {}          
          synthetic_test = [
            {
              url_suffix = "-pwclabs.pwcglb.com/api/v1/actuator/health"
              type       = "health"
            },
            {
              url_suffix = "-pwclabs.pwcglb.com"
              type       = "ssl"
            }
          ]
          synthetic_oauth_login_test = []
          critical_alerts = [
            {
              high_error_rate = [
                "get_/sites",
                "get_/sites/_siteid_/users",
                "post_/sites/_siteid_/users",
                "get_/sites/_siteid_/workbooks/projects/_projectid",
              ]
              query = null
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "1.2", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            }
          ]
          
        },
        {
          name        = "Kube Utility"
          trace       = "servlet"
          set_we_tag  = false
          service_name = null
          notify_non_prod = "@teams-Orca_Non_Prod_Alerts_Channel"
          notify_prod = "@teams-Orca_Prod_Alerts_Channel"
          notify_her_monitors = ""
          tag_ciid = {
            us = "CI58685180"
            au = "CI58685184"
            eu = "CI58685186"
            sg = "CI58685188"
          }
          synthetic_test_url_prefix = "kube-utility-service"
          synthetics_mon_priority   = {}          
          synthetic_test = [
            {
              url_suffix = "-pwclabs.pwcglb.com/api/v1/actuator/health"
              type       = "health"
            },
            {
              url_suffix = "-pwclabs.pwcglb.com"
              type       = "ssl"
            }
          ]
          synthetic_oauth_login_test = []
          critical_alerts = []          
        },
        {
          name        = "Viz CMD API"
          trace       = "servlet"
          set_we_tag  = false
          service_name = null
          notify_non_prod = "@teams-Orca_Non_Prod_Alerts_Channel"
          notify_prod = "@teams-Orca_Prod_Alerts_Channel"
          notify_her_monitors = ""
          tag_ciid = {
            us = "CI58685180"
            au = "CI58685184"
            eu = "CI58685186"
            sg = "CI58685188"
          }
          synthetic_test_url_prefix = "viz-cmd-api"
          synthetics_mon_priority   = {}          
          synthetic_test = [
            {
              url_suffix = "-pwclabs.pwcglb.com/api/v2/actuator/health"
              type       = "health"
            },
            {
              url_suffix = "-pwclabs.pwcglb.com"
              type       = "ssl"
            }
          ]
          synthetic_oauth_login_test = []
          critical_alerts = [
          {
              high_error_rate = [
                "patch_/workspaces/_workspaceid_/assets/_bitoolassetid_/legacyshare",
                "delete_/workspaces/_workspaceid_/assets/_bitoolassetid_/legacyshare",             
              ]
              query = null
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "1.2", eu_stg = "0.05", us_prod = "0.05", eu_prod = "1", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            } 
          ]         
        },
        {
          name        = "Viz Management API"
          trace       = "servlet"
          set_we_tag  = false
          service_name = null
          notify_non_prod = "@teams-Orca_Non_Prod_Alerts_Channel"
          notify_prod = "@teams-Orca_Prod_Alerts_Channel"
          notify_her_monitors = ""
          tag_ciid = {
            us = "CI58685180"
            au = "CI58685184"
            eu = "CI58685186"
            sg = "CI58685188"
          }
          synthetic_test_url_prefix = "viz-management-api"
          synthetics_mon_priority   = {}          
          synthetic_test = [
            {
              url_suffix = "-pwclabs.pwcglb.com/api/v2/actuator/health"
              type       = "health"
            },
            {
              url_suffix = "-pwclabs.pwcglb.com"
              type       = "ssl"
            }
          ]
          synthetic_oauth_login_test = []
          critical_alerts = [            
            {
              high_error_rate = [
                "delete_/workspaces/_workspaceid",
                "404",
                "patch_/assets/_approvaltrackingid",
                "put_/workspaces/asset/create",
                "get_/capacities", 
                "get_/groups/_groupid"              
              ]
              query = null
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "1.2", eu_stg = "0.05", us_prod = "0.05", eu_prod = "1", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            }
         ]
          
        },
        {
          name        = "Viz Query API"
          trace       = "servlet"
          set_we_tag  = false
          service_name = null
          notify_non_prod = "@teams-Orca_Non_Prod_Alerts_Channel"
          notify_prod = "@teams-Orca_Prod_Alerts_Channel"
          notify_her_monitors = ""
          tag_ciid = {
            us = "CI58685180"
            au = "CI58685184"
            eu = "CI58685186"
            sg = "CI58685188"
          }
          synthetic_test_url_prefix = "viz-query-api"
          synthetics_mon_priority   = {}           
          synthetic_test = [
            {
              url_suffix = "-pwclabs.pwcglb.com/api/v2/actuator/health"
              type       = "health"
            },
            {
              url_suffix = "-pwclabs.pwcglb.com"
              type       = "ssl"
            }
          ]
          synthetic_oauth_login_test = []
          critical_alerts = [            
            {
              high_error_rate = [
                "get_/workspaces/_workspaceid",
                "get_/tracking/_trackingid",
                "get_/workspaces/_workspaceid_/assets/_assetid_/share",
                "get_/share/_sharelink_/embed",
                "get_/roles",                
              ]
              query = null
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "1.2", eu_stg = "0.05", us_prod = "0.05", eu_prod = "1", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            }
         ]
          
        },
        {
          name        = "Notification"
          trace       = "servlet"
          set_we_tag  = false
          service_name = null
          notify_non_prod   = ""
          notify_prod       = ""
          notify_her_monitors = ""
          tag_ciid = {
            us = ""
            au = ""
            eu = ""
            sg = ""
          }
          synthetic_test_url_prefix = "notification"
          synthetics_mon_priority   = {}           
          synthetic_test = [
            {
              url_suffix = "-pwclabs.pwcglb.com/heartbeat"
              type       = "health"
            },
            {
              url_suffix = "-pwclabs.pwcglb.com"
              type       = "ssl"
            }
          ]
          synthetic_oauth_login_test = []
          critical_alerts = []
          
        },
        {
          name        = "VizInsights"
          trace       = "servlet"
          set_we_tag  = false
          service_name = null
          notify_non_prod = "@teams-Orca_Non_Prod_Alerts_Channel"
          notify_prod = "@teams-Orca_Prod_Alerts_Channel"
          notify_her_monitors = ""
          tag_ciid = {
            us = "CI58685180"
            au = "CI58685184"
            eu = "CI58685186"
            sg = "CI58685188"
          }
          synthetic_test_url_prefix = "vizinsights"
          synthetics_mon_priority   = {}           
          synthetic_test = [
            {
              url_suffix = "-pwclabs.pwcglb.com/api/v1/actuator/health"
              type       = "health"
            },
            {
              url_suffix = "-pwclabs.pwcglb.com"
              type       = "ssl"
            }
          ]
          synthetic_oauth_login_test = []
          critical_alerts = [
            {
              high_error_rate = [
                "get_/admin/code/_code",
                "get_/powerbi/clients/_clientid_/engagements/_engagementid_/assets",
                "get_/powerbi/clients/_clientid_/engagements/_engagementid_/assets/_assetid_/exports/_exportid",
                "get_/tableau/clients/_clientid_/engagements/_engagementid",
                "get_/tableau/clients/_clientid_/engagements/_engagementid_/assets",                
              ]
              query = null
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "1.2", eu_stg = "0.05", us_prod = "0.05", eu_prod = "1", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            }
          ]
        },
        {
          name        = "feature-legacy"
          trace       = "django"
          set_we_tag  = false
          service_name = null
          notify_non_prod = "@teams-Orca_Non_Prod_Alerts_Channel"
          notify_prod = "@teams-Orca_Prod_Alerts_Channel"
          notify_her_monitors = ""
          tag_ciid = {
            us = ""
            au = ""
            eu = ""
            sg = ""
          }
          synthetic_test_url_prefix = "feature-service-legacy"
          synthetics_mon_priority   = {}
          synthetic_test = [
            {
              url_suffix = "-pwclabs.pwcglb.com/health"
              type       = "health"
            },
            {
              url_suffix = "-pwclabs.pwcglb.com"
              type       = "ssl"
            }
          ]
          synthetic_oauth_login_test = []
          critical_alerts = [
            {
              high_error_rate = [
                "get_api/v4/feature-switch/user/_p_pwc_guid_0-9a-za-z_-"
              ]
              query = "sum(last_5m):(sum:trace.django.request.errors{env:##ENV##,service:feature-service-legacy,resource_name:get_api/v4/feature-switch/user/_p_pwc_guid_0-9a-za-z_- }.as_count() / sum:trace.django.request.hits{env:##ENV##,service:feature-service-legacy,resource_name:get_api/v4/feature-switch/user/_p_pwc_guid_0-9a-za-z_- }.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            }
          ]          
        },
        {
          name        = "engagement admin"
          trace       = "django"
          set_we_tag  = false
          service_name = "django-engagement-admin "
          notify_non_prod = "@teams-Orca_Non_Prod_Alerts_Channel"
          notify_prod = "@teams-Orca_Prod_Alerts_Channel"
          notify_her_monitors = ""
          tag_ciid = {
            us = "CI116457299"
            au = "CI116457301"
            eu = "CI116457303"
            sg = "CI116457305"
          }
          synthetic_test_url_prefix = "engagements"
          synthetics_mon_priority   = {}
          synthetic_test = [
            {
              url_suffix = "-pwclabs.pwcglb.com/health"
              type       = "health"
            },
            {
              url_suffix = "-pwclabs.pwcglb.com"
              type       = "ssl"
            }
          ]
          synthetic_oauth_login_test = []
          critical_alerts = []          
        },
        {
          name        = "MS Activity"
          trace       = "servlet"
          set_we_tag  = false
          service_name = null
          notify_non_prod = "@teams-Orca_Non_Prod_Alerts_Channel"
          notify_prod = "@teams-Orca_Prod_Alerts_Channel"
          notify_her_monitors = ""
          tag_ciid = {
            global = "CI117010551"
            us = "CI117163173"
            au = "CI117163175"
            eu = "CI117163177"
            sg = "CI117163179"
          }
          synthetic_test_url_prefix = "ms-activity-service"
          synthetics_mon_priority   = {}           
          synthetic_test = [
            {
              url_suffix = "-pwclabs.pwcglb.com/api/v1/actuator/health"
              type       = "health"
            },
            {
              url_suffix = "-pwclabs.pwcglb.com"
              type       = "ssl"
            }
          ]
          synthetic_oauth_login_test = []
          critical_alerts = []
          
        },
      ]
    },
    team_2 = {
      team_name = "TEAM_NAME_2"
      services = [
        {
          name        = "azure storage"
          trace       = "servlet"
          set_we_tag  = false
          service_name = null
          notify_non_prod   = "@teams-DD_BW_NonProd"
          notify_prod       = "@teams-DD_BW_Prod"
          notify_her_monitors = "@chiranjit.c.maity@pwc.com @hemanth.malka@pwc.com @alan.rossi@pwc.com"
          tag_ciid = {
            us = "CI116457267"
            au = "CI116457269"
            eu = "CI116457271"
            sg = "CI116457273"
          }
          synthetic_test_url_prefix = "azure-storage-service"
          synthetics_mon_priority   = {}
          synthetic_test = [
            {
              url_suffix = "-pwclabs.pwcglb.com/api/v1/actuator/health"
              type       = "health"
            },
            {
              url_suffix = "-pwclabs.pwcglb.com"
              type       = "ssl"
            }
          ]
          synthetic_oauth_login_test = []
          critical_alerts = [
            {
              high_error_rate = [
                "post_/blobs/properties"
              ]
              query = "sum(last_5m):(sum:trace.servlet.request.errors{env:##ENV##,service:azure-storage-service,resource_name:post_/blobs/properties }.as_count() / sum:trace.servlet.request.hits{env:##ENV##,service:azure-storage-service,resource_name:post_/blobs/properties }.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            },
            {
              high_error_rate = [
                "post_/filesystems/_filesystemname_/sastoken"
              ]
              query = "sum(last_5m):(sum:trace.servlet.request.errors{env:##ENV##,service:azure-storage-service,resource_name:post_/filesystems/_filesystemname_/sastoken  }.as_count() / sum:trace.servlet.request.hits{env:##ENV##,service:azure-storage-service,resource_name:post_/filesystems/_filesystemname_/sastoken  }.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            },
            {
              high_error_rate = [
                "post_/filesystems/_filesystemname_/blobs/sastoken"
              ]
              query = "sum(last_5m):(sum:trace.servlet.request.errors{env:##ENV##,service:azure-storage-service,resource_name:post_/filesystems/_filesystemname_/blobs/sastoken }.as_count() / sum:trace.servlet.request.hits{env:##ENV##,service:azure-storage-service,resource_name:post_/filesystems/_filesystemname_/blobs/sastoken }.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            },
            {
              high_error_rate = [
                "post_/filesystems/_filesystemname"
              ]
              query = "sum(last_5m):(sum:trace.servlet.request.errors{env:##ENV##,service:azure-storage-service,resource_name:post_/filesystems/_filesystemname }.as_count() / sum:trace.servlet.request.hits{env:##ENV##,service:azure-storage-service,resource_name:post_/filesystems/_filesystemname }.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            }
          ]
        },
        {
          name        = "directory"
          trace       = "servlet"
          set_we_tag  = false
          service_name = null
          notify_non_prod   = "@teams-DD_BW_NonProd"
          notify_prod       = "@teams-DD_BW_Prod"
          notify_her_monitors = "@chiranjit.c.maity@pwc.com @hemanth.malka@pwc.com @alan.rossi@pwc.com"
          tag_ciid = {
            us = "CI116457283"
            au = "CI116457285"
            eu = "CI116457287"
            sg = "CI116457289"
          }
          synthetic_test_url_prefix = "directory-service"
          synthetics_mon_priority   = {}
          synthetic_test = [
            {
              url_suffix = "-pwclabs.pwcglb.com/api/v1/actuator/health"
              type       = "health"
            },
            {
              url_suffix = "-pwclabs.pwcglb.com"
              type       = "ssl"
            }
          ]
          synthetic_oauth_login_test = []
          critical_alerts = [
            {
              high_error_rate = [
                "patch_/groups/_groupname", #creating monitors for this resource as per # 118283
                "post_/groups/validateusers", #creating monitors for this resource as per # 118283
                "put_/groups/_groupname_/appidmembers", #creating monitors for this resource as per # 118283
                "post_/groups/_groupuniqueid", #creating monitors for this resource as per # 118283
                "delete_/groups/_groupname", #creating monitors for this resource as per # 118283           
              ]
              query = null
              critical_threshold = {
                dev = "1", qa = "1", uat = "1", us_stg = "1", eu_stg = "1", us_prod = "1", eu_prod = "1", au_prod = "1", sg_prod = "1"
              }
              mon_priority = {}
            }
          ]
        },
        {
          name        = "engagement service v2"
          trace       = "servlet"
          set_we_tag  = false
          service_name = "engagement-service-v2"
          notify_non_prod   = "@teams-DD_BW_NonProd"
          notify_prod       = "@teams-DD_BW_Prod"
          notify_her_monitors = "@chiranjit.c.maity@pwc.com @hemanth.malka@pwc.com @alan.rossi@pwc.com"
          tag_ciid = {
            us = "CI116457313"
            au = "CI116457315"
            eu = "CI116457317"
            sg = "CI116457319"
          }
          synthetic_test_url_prefix = "engagement-service"
          synthetics_mon_priority   = {}
          synthetic_test = [
            {
              url_suffix = "-pwclabs.pwcglb.com/api/v2/actuator/health"
              type       = "health"
            },
            {
              url_suffix = "-pwclabs.pwcglb.com"
              type       = "ssl"
            }
          ]
          synthetic_oauth_login_test = []
          critical_alerts = [
            {
              high_error_rate = [
                "delete_/admin/engagements/_engagementid_/services/_servicename"
              ]
              query = "sum(last_5m):(sum:trace.servlet.request.errors{env:##ENV##,service:engagement-service-v2,resource_name:delete_/admin/engagements/_engagementid_/services/_servicename}.as_count() / sum:trace.servlet.request.hits{env:##ENV##,service:engagement-service-v2,resource_name:delete_/admin/engagements/_engagementid_/services/_servicename}.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            },
            {
              high_error_rate = [
                "get_/admin/engagements/_engagementid_/services"
              ]
              query = "sum(last_5m):(sum:trace.servlet.request.errors{env:##ENV##,service:engagement-service-v2,resource_name:get_/admin/engagements/_engagementid_/services}.as_count() / sum:trace.servlet.request.hits{env:##ENV##,service:engagement-service-v2,resource_name:get_/admin/engagements/_engagementid_/services}.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            },
            {
              high_error_rate = [
                "get_/admin/engagements/_engagementid_/connections"
              ]
              query = "sum(last_5m):(sum:trace.servlet.request.errors{env:##ENV##,service:engagement-service-v2,resource_name:get_/admin/engagements/_engagementid_/connections}.as_count() / sum:trace.servlet.request.hits{env:##ENV##,service:engagement-service-v2,resource_name:get_/admin/engagements/_engagementid_/connections}.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            },
            {
              high_error_rate = [
                "get_/engagements/_engagementid"
              ]
              query = "sum(last_5m):(sum:trace.servlet.request.errors{env:##ENV##,service:engagement-service-v2,resource_name:get_/engagements/_engagementid}.as_count() / sum:trace.servlet.request.hits{env:##ENV##,service:engagement-service-v2,resource_name:get_/engagements/_engagementid}.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            }, 
            {
              high_error_rate = [
                "put_/admin/engagements/_engagementid_/services/_servicename_/resources/_resourcename_/connections"
              ]
              query = "sum(last_5m):(sum:trace.servlet.request.errors{env:##ENV##,service:engagement-service-v2,resource_name:put_/admin/engagements/_engagementid_/services/_servicename_/resources/_resourcename_/connections}.as_count() / sum:trace.servlet.request.hits{env:##ENV##,service:engagement-service-v2,resource_name:put_/admin/engagements/_engagementid_/services/_servicename_/resources/_resourcename_/connections}.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            },                                       
          ]         
        },
        {
          name        = "fabric api v3"
          trace       = "servlet"
          set_we_tag  = false
          service_name = "fabric-api-v3"
          notify_non_prod   = "@teams-DD_BW_NonProd"
          notify_prod       = "@teams-DD_BW_Prod"
          notify_her_monitors = "@chiranjit.c.maity@pwc.com @hemanth.malka@pwc.com @alan.rossi@pwc.com"
          tag_ciid = {
            us = "CI116457321"
            au = "CI116457324"
            eu = "CI116457326"
            sg = "CI116457328"
          }
          synthetic_test_url_prefix  = "fabric-api"
          synthetics_mon_priority   = {}
          synthetic_test = [
            {
              url_suffix = "-pwclabs.pwcglb.com/api/v3/actuator/health"
              type       = "health"
            },
            {
              url_suffix = "-pwclabs.pwcglb.com"
              type       = "ssl"
            }
          ]
          synthetic_oauth_login_test = []
          critical_alerts = [
            {
              high_error_rate = [
                "get_/workspaces/_workspaceid_/sas"
              ]
              query = "sum(last_5m):(sum:trace.servlet.request.errors{env:##ENV##,service:fabric-api-v3,resource_name:get_/workspaces/_workspaceid_/sas }.as_count() / sum:trace.servlet.request.hits{env:##ENV##,service:fabric-api-v3,resource_name:get_/workspaces/_workspaceid_/sas }.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            },
            {
              high_error_rate = [
                "get_/workspaces/_workspaceid_/connections"
              ]
              query = "sum(last_5m):(sum:trace.servlet.request.errors{env:##ENV##,service:fabric-api-v3,resource_name:get_/workspaces/_workspaceid_/connections }.as_count() / sum:trace.servlet.request.hits{env:##ENV##,service:fabric-api-v3,resource_name:get_/workspaces/_workspaceid_/connections }.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            },
          ]          
        },
        {
          name        = "generic kafka producer"
          trace       = "servlet"
          set_we_tag  = false
          service_name = null
          notify_non_prod   = "@teams-DD_BW_NonProd"
          notify_prod       = "@teams-DD_BW_Prod"
          notify_her_monitors = "@chiranjit.c.maity@pwc.com @hemanth.malka@pwc.com @alan.rossi@pwc.com"
          tag_ciid = {
            us = "CI116457330"
            au = "CI116457332"
            eu = "CI116457334"
            sg = "CI116457336"
          }
          synthetic_test_url_prefix = "generic-kafka-producer"
          synthetics_mon_priority   = {}
          synthetic_test = [
            {
              url_suffix = "-pwclabs.pwcglb.com/api/v1/actuator/health"
              type       = "health"
            },
            {
              url_suffix = "-pwclabs.pwcglb.com"
              type       = "ssl"
            }
          ]
          synthetic_oauth_login_test = []
          critical_alerts = []
        },
        {
          name        = "ldap admin"
          trace       = "servlet"
          set_we_tag  = false
          service_name = null
          notify_non_prod   = "@teams-DD_BW_NonProd"
          notify_prod       = "@teams-DD_BW_Prod"
          notify_her_monitors = "@chiranjit.c.maity@pwc.com @hemanth.malka@pwc.com @alan.rossi@pwc.com"
          tag_ciid = {
            us = "CI116457354"
            au = "CI116457356"
            eu = "CI116457360"
            sg = "CI116457365"
          }
          synthetic_test_url_prefix = "ldap-admin-service"
          synthetics_mon_priority   = {}
          synthetic_test = [
            {
              url_suffix = "-pwclabs.pwcglb.com/api/v1/actuator/health"
              type       = "health"
            },
            {
              url_suffix = "-pwclabs.pwcglb.com"
              type       = "ssl"
            }
          ]
          synthetic_oauth_login_test = []
          critical_alerts = []      
        },
        {
          name        = "workspace aggregation handler"
          trace       = "servlet"
          set_we_tag  = false
          service_name = null
          notify_non_prod   = "@teams-DD_BW_NonProd"
          notify_prod       = "@teams-DD_BW_Prod"
          notify_her_monitors = "@chiranjit.c.maity@pwc.com @hemanth.malka@pwc.com @alan.rossi@pwc.com"
          tag_ciid = {
            us = "CI116457421"
            au = "CI41101427"
            eu = "CI41101419"
            sg = "CI58685029"
          }
          synthetic_test_url_prefix = "workspace-aggregation-handler"
          synthetics_mon_priority   = {}
          synthetic_test = [
            {
              url_suffix = "-pwclabs.pwcglb.com/api/v1/actuator/health"
              type       = "health"
            },
            {
              url_suffix = "-pwclabs.pwcglb.com"
              type       = "ssl"
            }
          ]
          synthetic_oauth_login_test = []
          critical_alerts = []          
        },
        {
          name        = "workspace event handler"
          trace       = "servlet"
          set_we_tag  = false
          service_name = null
          notify_non_prod   = "@teams-DD_BW_NonProd"
          notify_prod       = "@teams-DD_BW_Prod"
          notify_her_monitors = "@chiranjit.c.maity@pwc.com @hemanth.malka@pwc.com @alan.rossi@pwc.com"
          tag_ciid = {
            us = "CI116457421"
            au = "CI41101427"
            eu = "CI41101419"
            sg = "CI58685029"
          }
          synthetic_test_url_prefix = "workspace-event-handler"
          synthetics_mon_priority   = {}
          synthetic_test = [
            {
              url_suffix = "-pwclabs.pwcglb.com/api/v1/actuator/health"
              type       = "health"
            },
            {
              url_suffix = "-pwclabs.pwcglb.com"
              type       = "ssl"
            }
          ]
          synthetic_oauth_login_test = []
          critical_alerts = []
        },
        {
          name        = "workspace exp"
          trace       = "servlet"
          set_we_tag  = true
          service_name = null
          notify_non_prod   = "@teams-DD_BW_NonProd"
          notify_prod       = "@teams-DD_BW_Prod"
          notify_her_monitors = "@chiranjit.c.maity@pwc.com @hemanth.malka@pwc.com @alan.rossi@pwc.com"
          tag_ciid = {
            us = "CI119483161"
            au = "CI119483161"
            eu = "CI119483161"
            sg = "CI119483161"
          }
          synthetic_test_url_prefix = "workspace-exp"
          synthetics_mon_priority   = {}
          synthetic_test = [
            {
              url_suffix = "-pwclabs.pwcglb.com/api/v1/actuator/health"
              type       = "health"
            },
            {
              url_suffix = "-pwclabs.pwcglb.com"
              type       = "ssl"
            }
          ]
          synthetic_oauth_login_test = []
          critical_alerts = [
            {
              high_error_rate = [
                "post_/workspaces/search"
              ]
              query = "sum(last_5m):(sum:trace.servlet.request.errors{env:##ENV##,service:workspace-exp,resource_name:post_/workspaces/search }.as_count() / sum:trace.servlet.request.hits{env:##ENV##,service:workspace-exp,resource_name:post_/workspaces/search }.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            },
            {
              high_error_rate = [
                "get_/workspaces/_workspaceid"
              ]
              query = "sum(last_5m):(sum:trace.servlet.request.errors{env:##ENV##,service:workspace-exp,resource_name:get_/workspaces/_workspaceid }.as_count() / sum:trace.servlet.request.hits{env:##ENV##,service:workspace-exp,resource_name:get_/workspaces/_workspaceid }.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            },
            {
              high_error_rate = [
                "get_/public/workspaces/_workspaceid_/users/_userid"
              ]
              query = "sum(last_5m):(sum:trace.servlet.request.errors{env:##ENV##,service:workspace-exp,resource_name:get_/public/workspaces/_workspaceid_/users/_userid }.as_count() / sum:trace.servlet.request.hits{env:##ENV##,service:workspace-exp,resource_name:get_/public/workspaces/_workspaceid_/users/_userid }.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            }
          ]         
        },
        {
          name        = "workspace search handler"
          trace       = "servlet"
          set_we_tag  = false
          service_name = null
          notify_non_prod   = "@teams-DD_BW_NonProd"
          notify_prod       = "@teams-DD_BW_Prod"
          notify_her_monitors = "@chiranjit.c.maity@pwc.com @hemanth.malka@pwc.com @alan.rossi@pwc.com"
          tag_ciid = {
            us = "CI116457421"
            au = "CI41101427"
            eu = "CI41101419"
            sg = "CI58685029"
          }
          synthetic_test_url_prefix = "workspace-search-handler"
          synthetics_mon_priority   = {}
          synthetic_test = [
            {
              url_suffix = "-pwclabs.pwcglb.com/api/v1/actuator/health"
              type       = "health"
            },
            {
              url_suffix = "-pwclabs.pwcglb.com"
              type       = "ssl"
            }
          ]
          synthetic_oauth_login_test = []
          critical_alerts = []         
        },
        {
          name        = "workspace service"
          trace       = "servlet"
          set_we_tag  = false
          service_name = null
          notify_non_prod   = "@teams-DD_BW_NonProd"
          notify_prod       = "@teams-DD_BW_Prod"
          notify_her_monitors = "@chiranjit.c.maity@pwc.com @hemanth.malka@pwc.com @alan.rossi@pwc.com"
          tag_ciid = {
            us = "CI116457421"
            au = "CI41101427"
            eu = "CI41101419"
            sg = "CI58685029"
          }
          synthetic_test_url_prefix = "workspace-service"
          synthetics_mon_priority   = {}
          synthetic_test = [
            {
              url_suffix = "-pwclabs.pwcglb.com/api/v1/actuator/health"
              type       = "health"
            },
            {
              url_suffix = "-pwclabs.pwcglb.com"
              type       = "ssl"
            }
          ]
          synthetic_oauth_login_test = []
          critical_alerts = [
            {
              high_error_rate = [
                "get_/workspaces/_workspaceid"
              ]
              query = "sum(last_5m):(sum:trace.servlet.request.errors{env:##ENV##,service:workspace-service,resource_name:get_/workspaces/_workspaceid }.as_count() / sum:trace.servlet.request.hits{env:##ENV##,service:workspace-service,resource_name:get_/workspaces/_workspaceid }.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            },
            {
              high_error_rate = [
                "delete_/workspaces/_workspaceid"
              ]
              query = "sum(last_5m):(sum:trace.servlet.request.errors{env:##ENV##,service:workspace-service,resource_name:delete_/workspaces/_workspaceid }.as_count() / sum:trace.servlet.request.hits{env:##ENV##,service:workspace-service,resource_name:delete_/workspaces/_workspaceid }.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            },
            {
              high_error_rate = [
                "put_/workspaces/_workspaceid_/archive"
              ]
              query = "sum(last_5m):(sum:trace.servlet.request.errors{env:##ENV##,service:workspace-service,resource_name:put_/workspaces/_workspaceid_/archive }.as_count() / sum:trace.servlet.request.hits{env:##ENV##,service:workspace-service,resource_name:put_/workspaces/_workspaceid_/archive }.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            },
            {
              high_error_rate = [
                "put_/workspaces/_workspaceid_/pre-archive"
              ]
              query = "sum(last_5m):(sum:trace.servlet.request.errors{env:##ENV##,service:workspace-service,resource_name:put_/workspaces/_workspaceid_/pre-archive }.as_count() / sum:trace.servlet.request.hits{env:##ENV##,service:workspace-service,resource_name:put_/workspaces/_workspaceid_/pre-archive }.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            },
            {
              high_error_rate = [
                "post_/workspaces/search"
              ]
              query = "sum(last_5m):(sum:trace.servlet.request.errors{env:##ENV##,service:workspace-service,resource_name:post_/workspaces/search }.as_count() / sum:trace.servlet.request.hits{env:##ENV##,service:workspace-service,resource_name:post_/workspaces/search }.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            },
            {
              high_error_rate = [
                "post_/workspaces"
              ]
              query = "sum(last_5m):(sum:trace.servlet.request.errors{env:##ENV##,service:workspace-service,resource_name:post_/workspaces }.as_count() / sum:trace.servlet.request.hits{env:##ENV##,service:workspace-service,resource_name:post_/workspaces }.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            },
            {
              high_error_rate = [
                "patch_/workspaces/_workspaceid_/users"
              ]
              query = "sum(last_5m):(sum:trace.servlet.request.errors{env:##ENV##,service:workspace-service,resource_name:patch_/workspaces/_workspaceid_/users }.as_count() / sum:trace.servlet.request.hits{env:##ENV##,service:workspace-service,resource_name:patch_/workspaces/_workspaceid_/users }.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            },
            {
              high_error_rate = [
                "get_/workspaces/_workspaceid_/users"
              ]
              query = "sum(last_5m):(sum:trace.servlet.request.errors{env:##ENV##,service:workspace-service,resource_name:get_/workspaces/_workspaceid_/users }.as_count() / sum:trace.servlet.request.hits{env:##ENV##,service:workspace-service,resource_name:get_/workspaces/_workspaceid_/users }.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            }
          ]        
        },
        {
          name        = "ms-teams-wrapper"
          trace       = "aspnet_core"
          set_we_tag  = false
          service_name = null
          notify_non_prod   = "@teams-DD_BW_NonProd"
          notify_prod       = "@teams-DD_BW_Prod"
          notify_her_monitors = "@chiranjit.c.maity@pwc.com @hemanth.malka@pwc.com @alan.rossi@pwc.com"
          tag_ciid = {
            us = "CI116457421"
            au = "CI41101427"
            eu = "CI41101419"
            sg = "CI58685029"
          }
          synthetic_test_url_prefix  = "ms-teams-wrapper"
          synthetics_mon_priority   = {}
          synthetic_test = [
            {
              url_suffix = "-pwclabs.pwcglb.com"
              type       = "ssl"
            },
            {
              url_suffix = "-pwclabs.pwcglb.com/healthcheck"
              type       = "health"
            }
          ]
          synthetic_oauth_login_test = []
          critical_alerts = [
            {
              high_error_rate = [
                "ms-teams-wrapper_data_dog_tracer"
              ]
              query = "sum(last_10m):(sum:trace.ms_teams_wrapper_data_dog_tracer.errors{env:##ENV##,service:ms-teams-wrapper,resource_name:ms-teams-wrapper_data_dog_tracer}.as_count() / sum:trace.ms_teams_wrapper_data_dog_tracer.hits{env:##ENV##,service:ms-teams-wrapper,resource_name:ms-teams-wrapper_data_dog_tracer }.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            }
          ]       
        }
      ]
    },
    team_3 = {
      team_name = "TEAM_NAME_3"
      services = [
        {
          name        = "MFE"
          trace       = "aspnet_core"
          set_we_tag  = false
          service_name = null
          notify_non_prod   = "@teams-Sea_Lions_Non_Prod_Alerts_Channel"
          notify_prod       = "@teams-Sea_Lions_Prod_Alerts_Channel"
          notify_her_monitors = "@SeaLions-Monitoring-Notifications@groups.pwc.com"
          tag_ciid = {
            global = "CI117163297"
            us = "CI117163299"
            au = "CI117163301"
            eu = "CI117163303"
            sg = "CI117163305"
          }
          synthetic_test_url_prefix = "workbench-ng"
          synthetics_mon_priority   = {}
          synthetic_test = [
            {
              url_suffix   = "-pwclabs.pwcglb.com"
              type         = "ssl"
            }
          ]
          synthetic_oauth_login_test = []
          critical_alerts = []
          
        },
        {
          name        = "MFE Analytics"
          trace       = "aspnet_core"
          set_we_tag  = false
          service_name = "workbench-ng-analytics"
          notify_non_prod   = "@teams-Sea_Lions_Non_Prod_Alerts_Channel"
          notify_prod       = "@teams-Sea_Lions_Prod_Alerts_Channel"
          notify_her_monitors = "@SeaLions-Monitoring-Notifications@groups.pwc.com"
          tag_ciid = {
            global = "CI117010517"
            us = "CI117163181"
            au = "CI117163183"
            eu = "CI117163185"
            sg = "CI117163187"
          }
          synthetic_test_url_prefix = "workbench-ng"
          synthetics_mon_priority   = {}
          synthetic_test = [
            {
              url_suffix = "-pwclabs.pwcglb.com/api/analytics/v1/health"
              type       = "health"
            }
          ]
          synthetic_oauth_login_test = []
          critical_alerts = []
        },
        {
          name        = "MFE App Configuration"
          trace       = "aspnet_core"
          set_we_tag  = false
          service_name = "workbench-ng-app-configuration"
          notify_non_prod   = "@teams-Sea_Lions_Non_Prod_Alerts_Channel"
          notify_prod       = "@teams-Sea_Lions_Prod_Alerts_Channel"
          notify_her_monitors = "@SeaLions-Monitoring-Notifications@groups.pwc.com"
          tag_ciid = {
            global = "CI117010525"
            us = "CI117163197"
            au = "CI117163199"
            eu = "CI117163201"
            sg = "CI117163203"
          }
          synthetic_test_url_prefix = "workbench-ng"
          synthetics_mon_priority   = {}
          synthetic_test = [
            {
              url_suffix = "-pwclabs.pwcglb.com/api/app-configuration/v1/health"
              type       = "health"
            }
          ]
          synthetic_oauth_login_test = []
          critical_alerts = [
            {
              high_error_rate = [
                "get_/api/app-configuration/v_version_/app-configuration/app-settings/internal-domains"
              ]
              query = "sum(last_5m):(sum:trace.aspnet_core.request.errors{env:##ENV##,service:workbench-ng-app-configuration,resource_name:get_/api/app-configuration/v_version_/app-configuration/app-settings/internal-domains}.as_count() / sum:trace.aspnet_core.request.hits{env:##ENV##,service:workbench-ng-app-configuration,resource_name:get_/api/app-configuration/v_version_/app-configuration/app-settings/internal-domains}.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            },
            {
              high_error_rate = [
                "get_/api/app-configuration/v_version_/app-configuration/_key"
              ]
              query = "sum(last_5m):(sum:trace.aspnet_core.request.errors{env:##ENV##,service:workbench-ng-app-configuration,resource_name:get_/api/app-configuration/v_version_/app-configuration/_key}.as_count() / sum:trace.aspnet_core.request.hits{env:##ENV##,service:workbench-ng-app-configuration,resource_name:get_/api/app-configuration/v_version_/app-configuration/_key}.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            }
          ]
        },
        {
          name        = "MFE Authorization"
          trace       = "aspnet_core"
          set_we_tag  = false
          service_name = "workbench-ng-authorization"
          notify_non_prod   = "@teams-Sea_Lions_Non_Prod_Alerts_Channel"
          notify_prod       = "@teams-Sea_Lions_Prod_Alerts_Channel"
          notify_her_monitors = "@SeaLions-Monitoring-Notifications@groups.pwc.com"
          tag_ciid = {
            global = "CI117010523"
            us = "CI117163205"
            au = "CI117163207"
            eu = "CI117163209"
            sg = "CI117163211"
          }
          synthetic_test_url_prefix = "workbench-ng"
          synthetics_mon_priority   = {}
          synthetic_test = [
            {
              url_suffix = "-pwclabs.pwcglb.com/api/authorization/v1/health"
              type       = "health"
            }
          ]
          synthetic_oauth_login_test = []
          critical_alerts = [
            {
              high_error_rate = [
                "get_/api/authorization/v_version_/passport"
              ]
              query = "sum(last_5m):(sum:trace.aspnet_core.request.errors{env:##ENV##,service:workbench-ng-authorization,resource_name:get_/api/authorization/v_version_/passport}.as_count() / sum:trace.aspnet_core.request.hits{env:##ENV##,service:workbench-ng-authorization,resource_name:get_/api/authorization/v_version_/passport}.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            },
          ]
          
        },
        {
          name        = "MFE Content"
          trace       = "aspnet_core"
          set_we_tag  = false
          service_name = "workbench-ng-content"
          notify_non_prod   = "@teams-Sea_Lions_Non_Prod_Alerts_Channel"
          notify_prod       = "@teams-Sea_Lions_Prod_Alerts_Channel"
          notify_her_monitors = "@SeaLions-Monitoring-Notifications@groups.pwc.com"
          tag_ciid = {
            global = "CI117010521"
            us = "CI117163213"
            au = "CI117163215"
            eu = "CI117163217"
            sg = "CI117163219"
          }
          synthetic_test_url_prefix = "workbench-ng"
          synthetics_mon_priority   = {}
          synthetic_test = [
            {
              url_suffix = "-pwclabs.pwcglb.com/api/content/v1/health"
              type       = "health"
            }
          ]
          synthetic_oauth_login_test = []
          critical_alerts = [
          ]
          
        },
        {
          name        = "MFE Gallery"
          trace       = "aspnet_core"
          set_we_tag  = false
          service_name = "workbench-ng-gallery"
          notify_non_prod   = "@teams-Sea_Lions_Non_Prod_Alerts_Channel"
          notify_prod       = "@teams-Sea_Lions_Prod_Alerts_Channel"
          notify_her_monitors = "@SeaLions-Monitoring-Notifications@groups.pwc.com"
          tag_ciid = {
            global = "CI117010519"
            us = "CI117163221"
            au = "CI117163223"
            eu = "CI117163225"
            sg = "CI117163227"
          }
          synthetic_test_url_prefix = "workbench-ng"
          synthetics_mon_priority   = {}
          synthetic_test = [
            {
              url_suffix = "-pwclabs.pwcglb.com/api/gallery/v1/health"
              type       = "health"
            }
          ]
          synthetic_oauth_login_test = []
          critical_alerts = [
          ]
        },
        {
          name        = "MFE FrontEnds"
          trace       = "aspnet_core"
          set_we_tag  = false
          service_name = "workbench-ng-microfrontends"
          notify_non_prod   = "@teams-Sea_Lions_Non_Prod_Alerts_Channel"
          notify_prod       = "@teams-Sea_Lions_Prod_Alerts_Channel"
          notify_her_monitors = "@SeaLions-Monitoring-Notifications@groups.pwc.com"
          tag_ciid = {
            global = "CI117010527"
            us = "CI117163229"
            au = "CI117163231"
            eu = "CI117163233"
            sg = "CI117163235"
          }
          synthetic_test_url_prefix = "workbench-ng"
          synthetics_mon_priority   = {}
          synthetic_test = [
            {
              url_suffix = "-pwclabs.pwcglb.com/api/microfrontends/v1/health"
              type       = "health"
            }
          ]
          synthetic_oauth_login_test = []
          critical_alerts = [
            {
              high_error_rate = [
                "post_/eventhandlers/sitecreatedtopicevent"
              ]
              query = "sum(last_5m):(sum:trace.aspnet_core.request.errors{env:##ENV##,service:workbench-ng-microfrontends,resource_name:post_/eventhandlers/sitecreatedtopicevent}.as_count() / sum:trace.aspnet_core.request.hits{env:##ENV##,service:workbench-ng-microfrontends,resource_name:post_/eventhandlers/sitecreatedtopicevent}.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            },
            {
              high_error_rate = [
                "get_/api/microfrontends/v_version_/micro-frontends/importmap"
              ]
              query = "sum(last_5m):(sum:trace.aspnet_core.request.errors{env:##ENV##,service:workbench-ng-microfrontends,resource_name:get_/api/microfrontends/v_version_/micro-frontends/importmap}.as_count() / sum:trace.aspnet_core.request.hits{env:##ENV##,service:workbench-ng-microfrontends,resource_name:get_/api/microfrontends/v_version_/micro-frontends/importmap}.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            },
            {
              high_error_rate = [
                "get_/api/microfrontends/v_version_/micro-frontends"
              ]
              query = "sum(last_5m):(sum:trace.aspnet_core.request.errors{env:##ENV##,service:workbench-ng-microfrontends,resource_name:get_/api/microfrontends/v_version_/micro-frontends}.as_count() / sum:trace.aspnet_core.request.hits{env:##ENV##,service:workbench-ng-microfrontends,resource_name:get_/api/microfrontends/v_version_/micro-frontends}.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            },
          ]
          
        },
        {
          name        = "MFE Pages"
          trace       = "aspnet_core"
          set_we_tag  = false
          service_name = "workbench-ng-pages"
          notify_non_prod   = "@teams-Sea_Lions_Non_Prod_Alerts_Channel"
          notify_prod       = "@teams-Sea_Lions_Prod_Alerts_Channel"
          notify_her_monitors = "@SeaLions-Monitoring-Notifications@groups.pwc.com"
          tag_ciid = {
            global = "CI117010529"
            us = "CI117163237"
            au = "CI117163239"
            eu = "CI117163241"
            sg = "CI117163243"
          }
          synthetic_test_url_prefix = "workbench-ng"
          synthetics_mon_priority   = {}
          synthetic_test = [
            {
              url_suffix = "-pwclabs.pwcglb.com/api/pages/v1/health"
              type       = "health"
            }
          ]
          synthetic_oauth_login_test = []
          critical_alerts = [
            {
              high_error_rate = [
                "post_/eventhandlers/sitecreatedtopicevent"
              ]
              query = "sum(last_5m):(sum:trace.aspnet_core.request.errors{env:##ENV##,service:workbench-ng-pages,resource_name:post_/eventhandlers/sitecreatedtopicevent}.as_count() / sum:trace.aspnet_core.request.hits{env:##ENV##,service:workbench-ng-pages,resource_name:post_/eventhandlers/sitecreatedtopicevent}.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            },
            {
              high_error_rate = [
                "get_/api/pages/v_version_/pages"
              ]
              query = "sum(last_5m):(sum:trace.aspnet_core.request.errors{env:##ENV##,service:workbench-ng-pages,resource_name:get_/api/pages/v_version_/pages}.as_count() / sum:trace.aspnet_core.request.hits{env:##ENV##,service:workbench-ng-pages,resource_name:get_/api/pages/v_version_/pages}.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            },
          ]
        
        },
        {
          name        = "MFE Sites"
          trace       = "aspnet_core"
          set_we_tag  = false
          service_name = "workbench-ng-sites"
          notify_non_prod   = "@teams-Sea_Lions_Non_Prod_Alerts_Channel"
          notify_prod       = "@teams-Sea_Lions_Prod_Alerts_Channel"
          notify_her_monitors = "@SeaLions-Monitoring-Notifications@groups.pwc.com"
          tag_ciid = {
            global = "CI117010531"
            us = "CI117163245"
            au = "CI117163247"
            eu = "CI117163249"
            sg = "CI117163251"
          }
          synthetic_test_url_prefix = "workbench-ng"
          synthetics_mon_priority   = {}
          synthetic_test = [
            {
              url_suffix = "-pwclabs.pwcglb.com/api/sites/v1/health"
              type       = "health"
            }
          ]
          synthetic_oauth_login_test = []
          critical_alerts = [
            {
              high_error_rate = [
                "get_/api/sites/sitesandcontexts/_contexttype"
              ]
              query = "sum(last_5m):(sum:trace.aspnet_core.request.errors{env:##ENV##,service:workbench-ng-sites,resource_name:get_/api/sites/sitesandcontexts/_contexttype}.as_count() / sum:trace.aspnet_core.request.hits{env:##ENV##,service:workbench-ng-sites,resource_name:get_/api/sites/sitesandcontexts/_contexttype}.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            },
            {
              high_error_rate = [
                "post_/api/sites"
              ]
              query = "sum(last_5m):(sum:trace.aspnet_core.request.errors{env:##ENV##,service:workbench-ng-sites,resource_name:post_/api/sites}.as_count() / sum:trace.aspnet_core.request.hits{env:##ENV##,service:workbench-ng-sites,resource_name:post_/api/sites}.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            },
            {
              high_error_rate = [
                "get_/api/sites/v_version_/sites/_siteprefix"
              ]
              query = "sum(last_5m):(sum:trace.aspnet_core.request.errors{env:##ENV##,service:workbench-ng-sites,resource_name:get_/api/sites/v_version_/sites/_siteprefix}.as_count() / sum:trace.aspnet_core.request.hits{env:##ENV##,service:workbench-ng-sites,resource_name:get_/api/sites/v_version_/sites/_siteprefix}.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            },
          ]
          
        },
        {
          name        = "MFE User Directory"
          trace       = "aspnet_core"
          set_we_tag  = false
          service_name = "workbench-ng-user-directory"
          notify_non_prod   = "@teams-Sea_Lions_Non_Prod_Alerts_Channel"
          notify_prod       = "@teams-Sea_Lions_Prod_Alerts_Channel"
          notify_her_monitors = "@SeaLions-Monitoring-Notifications@groups.pwc.com"
          tag_ciid = {
            global = "CI117010533"
            us = "CI117163261"
            au = "CI117163264"
            eu = "CI117163267"
            sg = "CI117163269"
          }
          synthetic_test_url_prefix = "workbench-ng"
          synthetics_mon_priority   = {}
          synthetic_test = [
            {
              url_suffix = "-pwclabs.pwcglb.com/api/user-directory/v1/health"
              type       = "health"
            }
          ]
          synthetic_oauth_login_test = []
          critical_alerts = []
          
        },
        {
          name        = "WB MYDATA API"
          trace       = "aspnet_core"
          set_we_tag  = false
          service_name = "wb-mydata-api"
          notify_non_prod   = "@teams-Sea_Lions_Non_Prod_Alerts_Channel"
          notify_prod       = "@teams-Sea_Lions_Prod_Alerts_Channel"
          notify_her_monitors = "@SeaLions-Monitoring-Notifications@groups.pwc.com"
          tag_ciid = {
            global = "CI117163287"
            us = "CI117163293"
            au = "CI117163289"
            eu = "CI117163291"
            sg = "CI117163295"
          }
          synthetic_test_url_prefix = "wb-mydata-api"
          synthetics_mon_priority   = {}
          synthetic_test = [
            {
              url_suffix   = "-pwclabs.pwcglb.com"
              type         = "ssl"
            },
            {
              url_suffix = "-pwclabs.pwcglb.com/api/v1/health"
              type       = "health"
            }
          ]
          synthetic_oauth_login_test = []
          critical_alerts = [
            {
              high_error_rate = [
                "get_/api/v1/workspace/_workspaceid_/file-system"
              ]
              query = "sum(last_5m):(sum:trace.aspnet_core.request.errors{env:##ENV##,service:wb-mydata-api,resource_name:get_/api/v1/workspace/_workspaceid_/file-system}.as_count() / sum:trace.aspnet_core.request.hits{env:##ENV##,service:wb-mydata-api,resource_name:get_/api/v1/workspace/_workspaceid_/file-system}.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}

            },
          ]
        },
        {
          name        = "MFE Workspace Context Adapter"
          trace       = "aspnet_core"
          set_we_tag  = false
          service_name = "workbench-ng-workspace-context-adapter"
          notify_non_prod   = "@teams-Sea_Lions_Non_Prod_Alerts_Channel"
          notify_prod       = "@teams-Sea_Lions_Prod_Alerts_Channel"
          notify_her_monitors = "@SeaLions-Monitoring-Notifications@groups.pwc.com"
          tag_ciid = {
            global = "CI117010535"
            us = "CI117163271"
            au = "CI117163273"
            eu = "CI117163275"
            sg = "CI117163277"
          }
          synthetic_test_url_prefix = "workbench-ng"
          synthetics_mon_priority   = {}
          synthetic_test = [
            {
              url_suffix = "-pwclabs.pwcglb.com/api/workspace-context-adapter/v1/health"
              type       = "health"
            }
          ]
          synthetic_oauth_login_test = []
          critical_alerts = [
            {
              high_error_rate = [
                "get_/api/internal/workspace-context-adapter/v_version_/workspaces"
              ]
              query = "sum(last_5m):(sum:trace.aspnet_core.request.errors{env:##ENV##,service:workbench-ng-workspace-context-adapter,resource_name:get_/api/internal/workspace-context-adapter/v_version_/workspaces}.as_count() / sum:trace.aspnet_core.request.hits{env:##ENV##,service:workbench-ng-workspace-context-adapter,resource_name:get_/api/internal/workspace-context-adapter/v_version_/workspaces}.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            },
          ]
        }      
      ]
    },    
    team_5 = {
      team_name = "TEAM_NAME_4"
      services = [
        #autz service
        {
          name        = "autz"
          trace       = "servlet"
          set_we_tag  = true
          service_name = null
          notify_non_prod   = ""
          notify_prod       = ""
          notify_her_monitors = ""
          tag_ciid = {
            us = "CI116457257"
            au = "CI116457259"
            eu = "CI116457261"
            sg = "CI116457263"
          }
          synthetic_test_url_prefix = "autz-service"
          synthetics_mon_priority   = {}
          synthetic_test = [
            {
              url_suffix = "-pwclabs.pwcglb.com/api/v1/actuator/health"
              type       = "health"
            },
            {
              url_suffix = "-pwclabs.pwcglb.com"
              type       = "ssl"
            }
          ]
          synthetic_oauth_login_test = []
          critical_alerts = [
            {
              high_error_rate = [
                "get_/authorize/service/_servicename_/users/_guid",
                "get_/authorize/users/_guid_/services"
              ]
              query = null
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            },
          ] 
        },
        {
          name        = "dns"
          trace       = "servlet"
          set_we_tag  = false
          service_name = null
          notify_non_prod   = ""
          notify_prod       = ""
          notify_her_monitors = ""
          tag_ciid = {
            us = "CI116457291"
            au = "CI116457293"
            eu = "CI116457295"
            sg = "CI116457297"
          }
          synthetic_test_url_prefix = "dns-service"
          synthetics_mon_priority   = {}
          synthetic_test = [
            {
              url_suffix = "-pwclabs.pwcglb.com/api/v1/actuator/health"
              type       = "health"
            },
            {
              url_suffix = "-pwclabs.pwcglb.com"
              type       = "ssl"
            }
          ]
          synthetic_oauth_login_test = []
          critical_alerts = [
            {
              high_error_rate = [
                "post_/dns",
                "delete_/dns",
                "get_/build/info",
                "get_/dns/checkrecord",
                "get_/dns/resolvehost",
              ]
              query = null
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            }
          ]        
        },
        #kv-store ##add APM Monitors
        {
          name        = "kv store"
          trace       = "servlet"
          set_we_tag  = false
          service_name = null
          notify_non_prod   = ""
          notify_prod       = ""
          notify_her_monitors = ""
          tag_ciid = {
            us = "CI116457346"
            au = "CI116457348"
            eu = "CI116457350"
            sg = "CI116457352"
          }
          synthetic_test_url_prefix = "kv-store"
          synthetics_mon_priority   = {}
          synthetic_test = [
            {
              url_suffix = "-pwclabs.pwcglb.com/api/v1/actuator/health"
              type       = "health"
            },
            {
              url_suffix = "-pwclabs.pwcglb.com"
              type       = "ssl"
            }
          ]
          synthetic_oauth_login_test = []
          critical_alerts = []
        
        },
        #authz-service  
        {
          name        = "authz"
          trace       = "servlet"
          set_we_tag  = false
          service_name = null
          notify_non_prod   = ""
          notify_prod       = ""
          notify_her_monitors = ""
          tag_ciid = {
            us = "CI116457257"
            au = "CI116457259"
            eu = "CI116457261"
            sg = "CI116457263"
          }
          synthetic_test_url_prefix = "authz-service"
          synthetics_mon_priority   = {}
          synthetic_test = [
            {
              url_suffix = "-pwclabs.pwcglb.com/api/v1/actuator/health"
              type       = "health"
            },
            {
              url_suffix = "-pwclabs.pwcglb.com"
              type       = "ssl"
            }
          ]
          synthetic_oauth_login_test = []
          critical_alerts = [
            {
              high_error_rate = [
                "get_/usercontexts/user/_userid_/context/_contextid",
                "post_/usercontexts/batch"
              ]
              query = null
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            },
          ]
        },
        #dp-approval-service #noot belongs to Dolphins 
        {
          name        = "DP Approval"
          trace       = "servlet"
          set_we_tag  = true
          service_name = null
          notify_non_prod   = ""
          notify_prod       = ""
          notify_her_monitors = ""
          tag_ciid = {
            global = "CI117010547"
            us = "CI117163165"
            au = "CI117163167"
            eu = "CI117163169"
            sg = "CI117163171"
          }
          synthetic_test_url_prefix = "dp-approval-service"
          synthetics_mon_priority   = {}
          synthetic_test = [
            {
              url_suffix = "-pwclabs.pwcglb.com/api/v1/actuator/health"
              type       = "health"
            },
            {
              url_suffix = "-pwclabs.pwcglb.com"
              type       = "ssl"
            }
          ]
          synthetic_oauth_login_test = []
          critical_alerts = []
          
        },
        #preference-service
        {
          name        = "Preference"
          trace       = "servlet"
          set_we_tag  = false
          service_name = null
          notify_non_prod   = ""
          notify_prod       = ""
          notify_her_monitors = ""
          tag_ciid = {
            global = "CI114724037"
            us     = "CI116457375"
            eu     = "CI116457379"
            au     = "CI116457377"
            sg     = "CI116457381"
          }
          synthetic_test_url_prefix = "preference-service"
          synthetics_mon_priority   = {}
          synthetic_test = [
            {
              url_suffix = "-pwclabs.pwcglb.com/api/v1/actuator/health"
              type       = "health"
            },
            {
              url_suffix = "-pwclabs.pwcglb.com"
              type       = "ssl"
            }
          ]
          synthetic_oauth_login_test = []
          critical_alerts = [
            {
              high_error_rate = [
                "get_/preferences/contexts",
                "get_/preferences/users",
                "get_/preferences/country",
                "get_/preferences/contexts/preferenceNames",
                "get_/preferences/users/preferenceNames",
                "get_/preferences/country/preferenceNames"
              ]
              query = null
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            }]
          
          
        },
        #workspace-asset-mgmt
        {
          name        = "workspace asset mgmt"
          trace       = "servlet"
          set_we_tag  = false
          service_name = null
          notify_non_prod   = ""
          notify_prod       = ""
          notify_her_monitors = ""
          tag_ciid = {
            us = "CI116457415"
            au = "CI116457417"
            eu = "CI116457419"
            sg = "CI116457421"
          }
          synthetic_test_url_prefix = "workspace-asset-mgmt"
          synthetics_mon_priority   = {}
          synthetic_test = [
            {
              url_suffix = "-pwclabs.pwcglb.com/api/v1/swagger-ui/index.html"
              type       = "health"
            },
            {
              url_suffix = "-pwclabs.pwcglb.com"
              type       = "ssl"
            }
          ]
          synthetic_oauth_login_test = []
          critical_alerts = [
            {
              high_error_rate = [
                "get_/assetaccess/_id",
                "get_/assetaccess/asset/_assetid",
                "get_/client-requests/_clientrequestid_/assets",
                "get_/workspaces/_workspaceid_/client-requests",
                "post_/assetaccess/_workspaceid_/assets/search",
              ]
              query = null
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.2", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            }
          ]
          
        },
        #service-provisioning-api
        {
          name        = "Service Provisioning"
          trace       = "servlet"
          set_we_tag  = true
          service_name = null
          notify_non_prod   = ""
          notify_prod       = ""
          notify_her_monitors = ""
          tag_ciid = {
            us = "CI116457383"
            au = "CI116457385"
            eu = "CI116457387"
            sg = "CI116457389"
          }
          synthetic_test_url_prefix = "service-provisioning-api"
          synthetics_mon_priority   = {}
          synthetic_test = [
            {
              url_suffix = "-pwclabs.pwcglb.com/api/v1/actuator/health"
              type       = "health"
            },
            {
              url_suffix = "-pwclabs.pwcglb.com"
              type       = "ssl"
            }
          ]
          synthetic_oauth_login_test = []
          critical_alerts = [
            {
              high_error_rate = [
                "get_/serviceprovisioning/engagements/_engagementid_/features",
                "post_/serviceprovisioning/provisionservice/engagements/_engagementid_/features/_featureid",
                "get_/serviceprovisioning/engagements/_engagementid_/feature-status"
              ]
              query = null
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.5", eu_prod = "0.2", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            }
          ]
          
        },
        #dp-idbroker
        {
          name        = "idbroker"
          trace       = "servlet"
          set_we_tag  = false
          service_name = null
          notify_non_prod   = ""
          notify_prod       = ""
          notify_her_monitors = ""
          tag_ciid = {
            us = "CI116457338"
            au = "CI116457340"
            eu = "CI116457342"
            sg = "CI116457344"
          }
          synthetic_test_url_prefix = "dp-idbroker"
          synthetics_mon_priority   = {}
          synthetic_test = [
            {
              url_suffix = "-pwclabs.pwcglb.com/api/v1/actuator/health"
type       = "health"
            },
            {
              url_suffix = "-pwclabs.pwcglb.com"
              type       = "ssl"
            }
          ]
          synthetic_oauth_login_test = []
          critical_alerts = [
            {
              high_error_rate = [
                "get_/public/login",
                "post_/public/login"
              ]
              query = null
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            }
          ]
          
        },
        #catalogue-service
        {
          name        = "catalogue"
          trace       = "servlet"
          set_we_tag  = false
          service_name = null
          notify_non_prod   = ""
          notify_prod       = ""
          notify_her_monitors = ""
          tag_ciid = {
            us = "CI57709308"
            au = "CI57709396"
            eu = "CI57709393"
            sg = "CI57709398"
          }
          synthetic_test_url_prefix = "catalogue-service"
          synthetics_mon_priority   = {}
          synthetic_test = [
            {
              url_suffix = "-pwclabs.pwcglb.com/api/v2/actuator/health"
              type       = "health"
            },
          ]
          synthetic_oauth_login_test = []
          critical_alerts = [
            {
              high_error_rate = [
                "post_/assets/search",
                "get_/workspaces/_workspaceid",
                "put_/workspaces/_workspaceid_/assets/_id",
                "post_/workspaces/_workspaceid_/assets/search"
              ]
              query = null
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.09", eu_prod = "0.10", au_prod = "0.09", sg_prod = "0.09"
              }
              mon_priority = {}
            }
          ]
          
        },
        #workbench-service
        {
          name        = "workbench"
          trace       = "servlet"
          set_we_tag  = false
          service_name = null
          notify_non_prod   = ""
          notify_prod       = ""
          notify_her_monitors = ""
          tag_ciid = {
            us = "CI58685019"
            au = "CI58685023"
            eu = "CI58685025"
            sg = "CI58685027"
          }
          synthetic_test_url_prefix = "workbench-service"
          synthetics_mon_priority   = {}
          synthetic_test = [
            {
              url_suffix = "-pwclabs.pwcglb.com/api/v1/actuator/health"
              type       = "health"
            },
            {
              url_suffix = "-pwclabs.pwcglb.com"
              type       = "ssl"
            }
          ]
          synthetic_oauth_login_test = []
          critical_alerts = [
            {
              high_error_rate = [
                "post_/workspaces/_workspaceid_/servicedefinitions",
                "get_/workspaces/_workspaceid_/servicedefinitions",
                "get_/workspaces/_workspaceid_/servicedefinitioninstances/_servicedefinitioninstanceid",
                "get_/workspaces/_workspaceid_/servicedefinitioninstances",
                "patch_/workspaces/_workspaceid_/serviceinstances/_serviceinstanceid_/mapping",
                "get_/workspaces/_workspaceid_/mapping"
              ]
              query = null
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.30"
              }
              mon_priority = {}
            }
          ]
          
        },
        #service-definitions
        {
          name        = "service definitions"
          trace       = "servlet"
          set_we_tag  = false
          service_name = null
          notify_non_prod   = ""
          notify_prod       = ""
          notify_her_monitors = ""
          tag_ciid = {
            us = "CI119483165"
            au = "CI119483165"
            eu = "CI119483165"
            sg = "CI119483165"
          }
          synthetic_test_url_prefix = "service-definitions"
          synthetics_mon_priority   = {}
          synthetic_test = [
            {
              url_suffix = "-pwclabs.pwcglb.com/api/v1/actuator/health"
              type       = "health"
            },
            {
              url_suffix = "-pwclabs.pwcglb.com"
              type       = "ssl"
            }
          ]
          synthetic_oauth_login_test = []
          critical_alerts = [
            {
              high_error_rate = [
                "post_/servicedefinitioninstances",
                "get_/servicedefinitions/_servicedefinitionid",
                "get_/servicedefinitions",
                "get_/servicedefinitioninstances",
                "post_/servicedefinitions"
              ]
              query = null
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            }
          ]
          
        },
        #wbservices-api
        {
          name        = "WbServices api"
          trace       = "flask"
          set_we_tag  = false
          service_name = null
          notify_non_prod   = ""
          notify_prod       = ""
          notify_her_monitors = ""
          tag_ciid = {
            us = "CI40696030"
            au = "CI40678371"
            eu = "CI40687777"
            sg = "CI58685001"
          }
          synthetic_test_url_prefix = "wbservices-api"
          synthetics_mon_priority   = {}
          synthetic_test = [
            {
              url_suffix = "-pwclabs.pwcglb.com"
              type       = "ssl"
            }
          ]
          synthetic_oauth_login_test = []
          critical_alerts = [
            {
              high_error_rate = [
                "delete_/api/v1/wbservices/_uuid:engagement_id",
                "get_/api/v1/features/_feature_id",
                "get_/api/v1/wbservices/_uuid:engagement_id",
              ]
              query = null
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            }
          ]
          
        },
        {
          name        = "Workbench Node API"
          trace       = "express"
          set_we_tag  = false
          service_name = "workbench-node-api"
          notify_non_prod   = ""
          notify_prod       = ""
          notify_her_monitors = ""
          tag_ciid = {
            global = "CI116493304"
            us = "CI116457407"
            au = "CI116457409"
            eu = "CI116457411"
            sg = "CI116457413"
          }
          synthetic_test_url_prefix = "workbench"
          synthetics_mon_priority   = {}
          synthetic_test = [
            {
              url_suffix = "-pwclabs.pwcglb.com/api/actuator/health"
              type       = "health"
            },
            {
              url_suffix = "-pwclabs.pwcglb.com"
              type       = "ssl"
            }
          ]
          synthetic_oauth_login_test = []
          critical_alerts = [
            {
              high_error_rate = [
                "get_/api/v1/engagements/:engagementid/features"
              ]
              query = "sum(last_5m):(sum:trace.express.request.errors{env:##ENV##,service:workbench-node-api,resource_name:get_/api/v1/engagements/:engagementid/features }.as_count() / sum:trace.express.request.hits{env:##ENV##,service:workbench-node-api,resource_name:get_/api/v1/engagements/:engagementid/features }.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            },
            {
              high_error_rate = [
                "get_/api/v1/engagements"
              ]
              query = "sum(last_5m):(sum:trace.express.request.errors{env:##ENV##,service:workbench-node-api,resource_name:get_/api/v1/engagements}.as_count() / sum:trace.express.request.hits{env:##ENV##,service:workbench-node-api,resource_name:get_/api/v1/engagements}.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            },
            {
              high_error_rate = [
                "get_/api/v1/engagements/:engagementid/reports/:reportguid/export/:exportid/status"
              ]
              query = "sum(last_5m):(sum:trace.express.request.errors{env:##ENV##,service:workbench-node-api,resource_name:get_/api/v1/engagements/:engagementid/reports/:reportguid/export/:exportid/status}.as_count() / sum:trace.express.request.hits{env:##ENV##,service:workbench-node-api,resource_name:get_/api/v1/engagements/:engagementid/reports/:reportguid/export/:exportid/status}.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            },
            {
              high_error_rate = [
                "get_/api/v1/shared/:sharedkey/export/:exportid/status"
              ]
              query = "sum(last_5m):(sum:trace.express.request.errors{env:##ENV##,service:workbench-node-api,resource_name:get_/api/v1/shared/:sharedkey/export/:exportid/status}.as_count() / sum:trace.express.request.hits{env:##ENV##,service:workbench-node-api,resource_name:get_/api/v1/shared/:sharedkey/export/:exportid/status}.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            },
            {
              high_error_rate = [
                "post_/api/public/v1/engagements/:engagementid/features/:featureid"
              ]
              query = "sum(last_5m):(sum:trace.express.request.errors{env:##ENV##,service:workbench-node-api,resource_name:post_/api/public/v1/engagements/:engagementid/features/:featureid}.as_count() / sum:trace.express.request.hits{env:##ENV##,service:workbench-node-api,resource_name:post_/api/public/v1/engagements/:engagementid/features/:featureid}.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            },
            {
              high_error_rate = [
                "post_/api/v1/engagements"
              ]
              query = "sum(last_5m):(sum:trace.express.request.errors{env:##ENV##,service:workbench-node-api,resource_name:post_/api/v1/engagements}.as_count() / sum:trace.express.request.hits{env:##ENV##,service:workbench-node-api,resource_name:post_/api/v1/engagements}.as_count()) > 1"
              critical_threshold = {
                dev = "1", qa = "1", uat = "1", us_stg = "1", eu_stg = "1", us_prod = "1", eu_prod = "1", au_prod = "1", sg_prod = "1"
              }
              mon_priority = {}
            },
          ]
        },        
        {
          name        = "Alteryx Macros"
          trace       = "servlet"
          set_we_tag  = false
          service_name = null
          notify_non_prod   = ""
          notify_prod       = ""
          notify_her_monitors = ""
          tag_ciid = {
            global = "CI116457423"
            us = "CI116457241"
            au = "CI116457243"
            eu = "CI116457245"
            sg = "CI116457247"
          }
          synthetic_test_url_prefix = "alteryx-macros"
          synthetics_mon_priority   = {}
          synthetic_test = [
            {
              url_suffix = "-pwclabs.pwcglb.com/api/v1/actuator/health"
              type       = "health"
            },
            {
              url_suffix = "-pwclabs.pwcglb.com"
              type       = "ssl"
            }
          ]
          synthetic_oauth_login_test = []
          critical_alerts = [
            {
              high_error_rate = [
                "post_/engagements/_engagementid_/track-activity",                
                "get_/engagements/_userid",
                "get_/engagements/_engagementid_/files/_filename",
                "get_/engagements/_engagementid_/feature-instances",
                "get_/engagements/_engagementid_/data/upload-metadata-options",
                "get_/engagements/_engagementid_/data/file/download",
                "get_/engagements/_engagementid_/assets/_guid_/downloadurl",
                "get_/engagements/_engagementid_/assets/_assetid_/children",
                "get_/macro-download-installer/typeid/_typeid",                
              ]
              query = null
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            }            
          ]     
        },
        {
          name        = "dcam-api"
          trace       = "servlet"
          set_we_tag  = false
          service_name = "dcam-api"
          notify_non_prod   = ""
          notify_prod       = ""
          notify_her_monitors = ""
          tag_ciid = {
            us = "CI116457346"
            au = "CI116457348"
            eu = "CI116457350"
            sg = "CI116457352"
          }
          synthetic_test_url_prefix = "dcam-api"
          synthetics_mon_priority   = {}
          synthetic_test = [
            {
              url_suffix = "-pwclabs.pwcglb.com"
              type       = "ssl"
            }
          ]
          synthetic_oauth_login_test = []
          critical_alerts = []
        
        }              
      ]
    },
    team_7 = {
      team_name = "TEAM_NAME_6"
      services = [
        {
          name        = "catalogue-service-v3"
          trace       = "servlet"
          set_we_tag  = false
          service_name = null
          notify_non_prod   = "@teams-Captain_america_Non_Prod_Alerts_Channel"
          notify_prod       = "@teams-Captain_America_Prod_Alerts_Channel"
          notify_her_monitors = ""
          tag_ciid = {
            us = "CI57709308"
            au = "CI57709396"
            eu = "CI57709393"
            sg = "CI57709398"
          }
          synthetic_test_url_prefix = "catalogue-service"
          synthetics_mon_priority   = {}
          synthetic_test = [
            {
              url_suffix = "-pwclabs.pwcglb.com/api/v3/actuator/health"
              type       = "health"
            },
            {
              url_suffix = "-pwclabs.pwcglb.com"
              type       = "ssl"
            }
          ]
          synthetic_oauth_login_test = []
          critical_alerts = [
            {
              high_error_rate = [
                "get_/build/info"
              ]
              query = "sum(last_5m):(sum:trace.servlet.request.errors{env:##ENV##,service:catalogue-service-v3,resource_name:get_/build/info }.as_count() / sum:trace.servlet.request.hits{env:##ENV##,service:catalogue-service-v3,resource_name:get_/build/info }.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            },
            {
              high_error_rate = [
                "post_/assets/search",
                
              ]
              query = "sum(last_5m):(sum:trace.servlet.request.errors{env:##ENV##,service:catalogue-service-v3,resource_name:post_/assets/search }.as_count() / sum:trace.servlet.request.hits{env:##ENV##,service:catalogue-service-v3,resource_name:post_/assets/search }.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            },            
            {
              high_error_rate = [
                "delete_/assets/_id"
              ]
              query = "sum(last_5m):(sum:trace.servlet.request.errors{env:##ENV##,service:catalogue-service-v3,resource_name:delete_/assets/_id }.as_count() / sum:trace.servlet.request.hits{env:##ENV##,service:catalogue-service-v3,resource_name:delete_/assets/_id }.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            },            
            {
              high_error_rate = [
                "get_/assets/_id"
              ]
              query = "sum(last_5m):(sum:trace.servlet.request.errors{env:##ENV##,service:catalogue-service-v3,resource_name:get_/assets/_id }.as_count() / sum:trace.servlet.request.hits{env:##ENV##,service:catalogue-service-v3,resource_name:get_/assets/_id }.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            },            
            {
              high_error_rate = [
                "get_/assets/_id_/detailed"
              ]
              query = "sum(last_5m):(sum:trace.servlet.request.errors{env:##ENV##,service:catalogue-service-v3,resource_name:get_/assets/_id_/detailed }.as_count() / sum:trace.servlet.request.hits{env:##ENV##,service:catalogue-service-v3,resource_name:get_/assets/_id_/detailed }.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            },            
            {
              high_error_rate = [
                "get_/assets/_id_/lineage"
              ]
              query = "sum(last_5m):(sum:trace.servlet.request.errors{env:##ENV##,service:catalogue-service-v3,resource_name:get_/assets/_id_/lineage }.as_count() / sum:trace.servlet.request.hits{env:##ENV##,service:catalogue-service-v3,resource_name:get_/assets/_id_/lineage }.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            },            
            {
              high_error_rate = [
                "get_/policies/_userid"
              ]
              query = "sum(last_5m):(sum:trace.servlet.request.errors{env:##ENV##,service:catalogue-service-v3,resource_name:get_/policies/_userid }.as_count() / sum:trace.servlet.request.hits{env:##ENV##,service:catalogue-service-v3,resource_name:get_/policies/_userid }.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            },            
            {
              high_error_rate = [
                "get_/roles"
              ]
              query = "sum(last_5m):(sum:trace.servlet.request.errors{env:##ENV##,service:catalogue-service-v3,resource_name:get_/roles }.as_count() / sum:trace.servlet.request.hits{env:##ENV##,service:catalogue-service-v3,resource_name:get_/roles }.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            },            
            {
              high_error_rate = [
                "get_/roles/_rolename"
              ]
              query = "sum(last_5m):(sum:trace.servlet.request.errors{env:##ENV##,service:catalogue-service-v3,resource_name:get_/roles/_rolename }.as_count() / sum:trace.servlet.request.hits{env:##ENV##,service:catalogue-service-v3,resource_name:get_/roles/_rolename }.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            },            
            {
              high_error_rate = [
                "get_/types/_name"
              ]
              query = "sum(last_5m):(sum:trace.servlet.request.errors{env:##ENV##,service:catalogue-service-v3,resource_name:get_/types/_name }.as_count() / sum:trace.servlet.request.hits{env:##ENV##,service:catalogue-service-v3,resource_name:get_/types/_name }.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            },            
            {
              high_error_rate = [
                "get_/types/business-metadata"
              ]
              query = "sum(last_5m):(sum:trace.servlet.request.errors{env:##ENV##,service:catalogue-service-v3,resource_name:get_/types/business-metadata }.as_count() / sum:trace.servlet.request.hits{env:##ENV##,service:catalogue-service-v3,resource_name:get_/types/business-metadata }.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            },            
            {
              high_error_rate = [
                "get_/types/business-metadata/_name"
              ]
              query = "sum(last_5m):(sum:trace.servlet.request.errors{env:##ENV##,service:catalogue-service-v3,resource_name:get_/types/business-metadata/_name }.as_count() / sum:trace.servlet.request.hits{env:##ENV##,service:catalogue-service-v3,resource_name:get_/types/business-metadata/_name }.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            },            
            {
              high_error_rate = [
                "post_/assets"
              ]
              query = "sum(last_5m):(sum:trace.servlet.request.errors{env:##ENV##,service:catalogue-service-v3,resource_name:post_/assets }.as_count() / sum:trace.servlet.request.hits{env:##ENV##,service:catalogue-service-v3,resource_name:post_/assets }.as_count()) > 0.05"
              critical_threshold = {
                dev = "0.05", qa = "0.05", uat = "0.05", us_stg = "0.05", eu_stg = "0.05", us_prod = "0.05", eu_prod = "0.05", au_prod = "0.05", sg_prod = "0.05"
              }
              mon_priority = {}
            }

          ]
            
                    
        },

        {
          name        = "DP Approval v2"
          trace       = "servlet"
          set_we_tag  = true
          service_name = null
          notify_non_prod   = ""
          notify_prod       = "@teams-Captain_America_Prod_Alerts_Channel"
          notify_her_monitors = ""
          tag_ciid = {
            global = "CI117010547"
            us = "CI117163165"
            au = "CI117163167"
            eu = "CI117163169"
            sg = "CI117163171"
          }
          synthetic_test_url_prefix = "dp-approval-service"
          synthetics_mon_priority   = {}
          synthetic_test = [
            {
              url_suffix = "-pwclabs.pwcglb.com/api/v2/actuator/health"
              type       = "health"
            },
            {
              url_suffix = "-pwclabs.pwcglb.com"
              type       = "ssl"
            }
          ]
          synthetic_oauth_login_test = []
          critical_alerts = []
          
        },        
        # {
        #   name        = "Discovery"
        #   notify_her_monitors = ""
        #  tag_ciid = {
        #     us = "CI119483173"
        #     au = "CI119483173"
        #     eu = "CI119483173"
        #     sg = "CI119483173"
        #   }
        #   synthetic_test_url_prefix = "discovery-service"
        #   synthetic_test =    [
        #     {
        #       url_suffix = "-pwclabs.pwcglb.com/api/v1/actuator/health"
        #       type       = "health"
        #     },
        #     {
        #       url_suffix = "-pwclabs.pwcglb.com"
        #       type       = "ssl"
        #     }
        #   ]
        #   synthetic_oauth_login_test = []
        #   critical_alerts = []
        # },
        {
          name        = "data access mgmt"
          trace       = "servlet"
          set_we_tag  = true
          service_name = null
          notify_non_prod   = ""
          notify_prod       = ""
          notify_her_monitors = ""
          tag_ciid = {
            us = "CI57709308"
            au = "CI57709396"
            eu = "CI57709393"
            sg = "CI57709398"
          }
          synthetic_test_url_prefix = "data-access-mgmt"
          synthetics_mon_priority   = {}
          synthetic_test = [
            {
              url_suffix = "-pwclabs.pwcglb.com/api/v1/swagger-ui/index.html"
              type       = "health"
            },
            {
              url_suffix = "-pwclabs.pwcglb.com"
              type       = "ssl"
            }
          ]
          synthetic_oauth_login_test = []
          critical_alerts = []
          
        },              
        
        {
          name        = "adf"
          trace       = "servlet"
          set_we_tag  = true
          service_name = null
          notify_non_prod   = ""
          notify_prod       = ""
          notify_her_monitors = ""
          tag_ciid = {
            us = "CI116457443"
            au = "CI116457324"
            eu = "CI116457326"
            sg = "CI116457328"
          }
          synthetic_test_url_prefix = "adf-service"
          synthetics_mon_priority   = {}
          synthetic_test = [
            {
              url_suffix = "-pwclabs.pwcglb.com/api/v1/actuator/health"
              type       = "health"
            },
            {
              url_suffix = "-pwclabs.pwcglb.com"
              type       = "ssl"
            }
          ]
          synthetic_oauth_login_test = []
          critical_alerts = []
          
        }
      ]
    }
  }
}


variable "teams_critical_slo_custom" {
  description = "List of health monitors for all teams and their services"
  type      =  map(any)
  default = {
    team_8 = {
      team_name = "TEAM_NAME_4"
      services = [
        {
          name        = "Workbench Node API"
          tag_ciid = {
            global = "CI116493304"
            us = "CI116457407"
            au = "CI116457409"
            eu = "CI116457411"
            sg = "CI116457413"
          }
          critical_alerts = [
            {
              high_error_rate = [
                "get_/api/v1/engagements/:engagementid/features",
                "get_/api/v1/engagements",
                "get_/api/v1/engagements/:engagementid/reports/:reportguid/export/:exportid/status",
                "get_/api/v1/shared/:sharedkey/export/:exportid/status",
                "post_/api/public/v1/engagements/:engagementid/features/:featureid",
                "post_/api/v1/engagements"
              ]              
            }            
          ]
        }
      ]
    }
    team_2 = {
      team_name = "TEAM_NAME_2"
      services = [
        {
          name        = "django-engagement-admin"
          tag_ciid = {
            us = "CI116457299"
            au = "CI116457301"
            eu = "CI116457303"
            sg = "CI116457305"
          }
          critical_alerts = [
            {
              high_error_rate = [
                "get_api/v1/engagement/",
                "get_api/v1/engagement/_p_pk_/._/",
                "get_api/v1/users",
                "post_api/rbac/v1/check"
              ]
              
            },
            
          ]
        },
        {
          name        = "engagement service v2"
          tag_ciid = {
            us = "CI116457313"
            au = "CI116457315"
            eu = "CI116457317"
            sg = "CI116457319"
          }
          critical_alerts = [
            {
              high_error_rate = [
                "delete_/admin/engagements/_engagementid_/services/_servicename",
                "get_/admin/engagements/_engagementid_/services",
                "get_/admin/engagements/_engagementid_/connections",
                "get_/engagements/_engagementid",
                "put_/admin/engagements/_engagementid_/services/_servicename_/resources/_resourcename_/connections"
              ]
            }
          ]
        },
        {
          name        = "fabric api v3"
          tag_ciid = {
            us = "CI116457321"
            au = "CI116457324"
            eu = "CI116457326"
            sg = "CI116457328"
          }
          critical_alerts = [
            {
              high_error_rate = [
                "get_/workspaces/_workspaceid_/sas", 
                "get_/workspaces/_workspaceid_/connections"
              ]
            }
          ]
        },
        {
          name        = "workspace exp"
          tag_ciid = {
            us = "" #tobecompleted
            au = "" #tobecompleted
            eu = "" #tobecompleted
            sg = "" #tobecompleted
          }
          critical_alerts = [
            {
              high_error_rate = [
                "post_/workspaces/search", 
                "get_/workspaces/_workspaceid",
                "get_/public/workspaces/_workspaceid_/users/_userid"
              ]
            }
          ]
        },
      ]
    },
    team_3 = {
      team_name = "TEAM_NAME_3"
      services = [
        {
          name        = "MFE Authorization"
          tag_ciid = {
            global = "CI117010523"
            us = "CI117163205"
            au = "CI117163207"
            eu = "CI117163209"
            sg = "CI117163211"
          }
          critical_alerts = [

            {
              high_error_rate = [
                "get_/api/authorization/v_version_/passport"
              ]
            }
          ]
        },
        {
          name        = "MFE Analytics"
          tag_ciid = {
            global = "CI117010517"
            us = "CI117163181"
            au = "CI117163183"
            eu = "CI117163185"
            sg = "CI117163187"
          }
          critical_alerts = [

            {
              high_error_rate = []
            }
          ]
        },
        {
          name        = "MFE FrontEnds"
          tag_ciid = {
            global = "CI117010527"
            us = "CI117163229"
            au = "CI117163231"
            eu = "CI117163233"
            sg = "CI117163235"
          }
          critical_alerts = [
            {
              high_error_rate = [
                "post_/eventhandlers/sitecreatedtopicevent",
                "get_/api/microfrontends/v_version_/micro-frontends/importmap",
                "get_/api/microfrontends/v_version_/micro-frontends"
              ]
              
            },
          ]
        },
        {
          name        = "MFE Pages"
          tag_ciid = {
            global = "CI117010529"
            us = "CI117163237"
            au = "CI117163239"
            eu = "CI117163241"
            sg = "CI117163243"
          }
          critical_alerts = [
            {
              high_error_rate = [
                "post_/eventhandlers/sitecreatedtopicevent",
                "get_/api/pages/v_version_/pages"
              ]
            },
          ]
        },
        {
          name        = "MFE Sites"
          tag_ciid = {
            global = "CI117010531"
            us = "CI117163245"
            au = "CI117163247"
            eu = "CI117163249"
            sg = "CI117163251"
          }
          
          critical_alerts = [
            {
              high_error_rate = [
                "get_/api/sites/sitesandcontexts/_contexttype",
                "post_/api/sites",
                "get_/api/sites/v_version_/sites/_siteprefix"
              ]
              
            },
          ]
        },
        {
          name        = "WB MYDATA API"
          tag_ciid = {
            global = "CI117163287"
            us = "CI117163293"
            au = "CI117163289"
            eu = "CI117163291"
            sg = "CI117163295"
          }
          
          critical_alerts = [
            {
              high_error_rate = [
                "get_/api/v1/workspace/_workspaceid_/file-system"
              ]
              
            },
          ]
        },
        {
          name        = "MFE Workspace Context Adapter"
          tag_ciid = {
            global = "CI117163287"
            us = "CI117163293"
            au = "CI117163289"
            eu = "CI117163291"
            sg = "CI117163295"
          }
          
          critical_alerts = [
            {
              high_error_rate = [
                "get_/api/internal/workspace-context-adapter/v_version_/workspaces"
              ]
              
            },
          ]
        },
        {
          name        = "MFE App Configuration"
          tag_ciid = {
            global = "CI117010525"
            us = "CI117163197"
            au = "CI117163199"
            eu = "CI117163201"
            sg = "CI117163203"
          }          
          critical_alerts = [
            {
              high_error_rate = [
                "get_/api/app-configuration/v_version_/app-configuration/app-settings/internal-domains",
                "get_/api/app-configuration/v_version_/app-configuration/_key"
              ]
              
            },
          ]
        },
      ]
    },
    team_4 = {
      team_name = "TEAM_NAME_6"
      services = [
        {
          name        = "catalogue-service-v3"
          tag_ciid = {
            us = "CI57709308"
            au = "CI57709396"
            eu = "CI57709393"
            sg = "CI57709398"
          }
          critical_alerts = [
            {
              high_error_rate = [
                "delete_/assets/_id",
                "get_/assets/_id",
                "get_/assets/_id_/detailed",
                "get_/assets/_id_/lineage",
                "get_/policies/_userid",
                "get_/roles",
                "get_/roles/_rolename",
                "get_/types/_name",
                "get_/types/business-metadata",
                "get_/types/business-metadata/_name",
                "post_/assets",
                "post_/assets/search"
              ]
              
            }         
          ]
        },
      ]
    }
   }
}

variable "nifi_kube_cluster_name" {
  default = {
    dev    = "us-nifi-lower-l002-pzi-gxus-g-sub046"
    qa     = "us-nifi-lower-l002-pzi-gxus-g-sub046"
    uat    = "us-uat-platform-nifi-aks-001"
    us_stg = "us-nifi-nonprod-n002-pzi-gxus-n-sub038"
    eu_stg = "we-nifi-nonprod-n002-pzi-gxeu-g-sub023"
    us_prod = "us-nifi-prod-p002-pzi-gxus-p-sub079"
    eu_prod = "we-nifi-prod-p002-pzi-gxeu-p-sub052"
    au_prod = "au-nifi-prod-p002-pzi-gxau-p-sub015"
    sg_prod = "sg-prod-platform-nifi-aks-001"
  }
}
variable "nifi_kube_cluster_team_name" {
  default = {    
    dev    = "us-nifi-lower-l002-pzi-gxus-g-sub046"
    qa     = "us-nifi-lower-l002-pzi-gxus-g-sub046"
    uat    = "us-uat-platform-nifi-aks-001"
    us_stg = "us-nifi-nonprod-n002-pzi-gxus-n-sub038"
    eu_stg = "we-nifi-nonprod-n002-pzi-gxeu-g-sub023"
    us_prod = "us-nifi-prod-p002-pzi-gxus-p-sub079"
    eu_prod = "we-nifi-prod-p002-pzi-gxeu-p-sub052"
    au_prod = "au-nifi-prod-p002-pzi-gxau-p-sub015"
    sg_prod = "sg-prod-platform-nifi-aks-001"
  }
}

variable "nifi_tag_ciid" {
  default = {
    us = "CI116457367"
    au = "CI116457369"
    eu = "CI116457371"
    sg = "CI116457373"
  }
}

variable "dp_kube_cluster_name" {
  default = {
    dev    = "us-dev-platform-apps-aks-001"
    qa     = "us-qa-platform-apps-aks-001"
    uat    = "us-uat-platform-apps-aks-001"
    us_stg = "us-stage-platform-apps-aks-001"
    eu_stg = "we-platform-nonprod-n001-pzi-gxeu-g-sub023"
    us_prod = "us-platform-prod-p001-pzi-gxus-p-sub079"
    eu_prod = "we-platform-prod-p001-pzi-gxeu-p-sub052"
    au_prod = "au-platform-prod-p001-pzi-gxau-p-sub015"
    sg_prod = "sg-prod-platform-apps-aks-001"
  }
}
variable "dp_kube_cluster_team_name" {
  default = { 
    dev    = "us-dev-platform-apps-aks-001"
    qa     = "us-qa-platform-apps-aks-001"
    uat    = "us-uat-platform-apps-aks-001"   
    us_stg = "us-stage-platform-apps-aks-001"
    eu_stg = "we-platform-nonprod-n001-pzi-gxeu-g-sub023"
    us_prod = "us-platform-prod-p001-pzi-gxus-p-sub079"
    eu_prod = "we-platform-prod-p001-pzi-gxeu-p-sub052"
    au_prod = "au-platform-prod-p001-pzi-gxau-p-sub015"
    sg_prod = "sg-prod-platform-apps-aks-001"
  }
}

variable "kube_namespace_values" {
  default = {
    dev    = "dp-services-us-dev"
    qa     = "dp-services-us-qa"
    uat    = "dp-services-us-uat"
    us_stg = "dp-services-us-stage"
    eu_stg = "dp-services-eu-stage"
    us_prod = "dp-services-us-prod"
    eu_prod = "dp-services-eu-prod"
    au_prod = "dataplatform-au-prod"
    sg_prod = "dp-services-sg-prod"
  }
}

variable "mfe_kube_namespace_values" {
  default = {
    dev    = "dp-mfe-us-dev"
    qa     = "dp-mfe-us-qa"
    us_stg = "dp-mfe-us-stage"
    eu_stg = "dp-mfe-eu-stage"
    us_prod = "dp-mfe-us-prod"
    eu_prod = "dp-mfe-eu-prod"
    au_prod = "dp-mfe-au-prod"
    sg_prod = "dp-mfe-sg-prod"
  }
}

variable "kube_namespace_team_values" {
  default = {   
    dev    = "dp-services-us-dev"
    qa     = "dp-services-us-qa"
    uat    = "dp-services-us-uat" 
    us_stg = "dp-services-us-stage"
    eu_stg = "dp-services-eu-stage"
    us_prod = "dp-services-us-prod"
    eu_prod = "dp-services-eu-prod"
    au_prod = "dataplatform-au-prod"
    sg_prod = "dp-services-sg-prod"
  }
}

variable "monitors_priority" {
default = {
    dev    = "3"
    qa     = "3"
    uat    = "3" 
    us_stg = "3"
    eu_stg = "3"
    us_prod = "3"
    eu_prod = "3"
    au_prod = "3"
    sg_prod = "3"
  }
}
variable "custom_monitor_val" {
  description = "List of custom monitors for all teams and their services"
  type        = map(any)
  default = {
    team_1 = {
      team_name = "TEAM_NAME_6"
      services = [
        {
          name         = "catalogue-service"
          metrics_type = "custom"
          tag_ciid = {
            global = "CI57709054"
            us     = "CI57709308"
            au     = "CI57709396"
            eu     = "CI57709393"
            sg     = "CI57709398"
          }
          custom_monitor = []
        }
      ]
    },
    team_4 = {
      team_name = "TEAM_NAME_4"
      services = [
        {
          name         = "id_broker"
          metrics_type = "service"
          tag_ciid = {
            global = "CI116457447"
            us     = "CI116457338"
            au     = "CI116457340"
            eu     = "CI116457342"
            sg     = "CI116457344"
          }
          custom_monitor = [
            {
              enable_namespace_val = true
              namespace_val        = {}
              alert_name           = "Idbroker Pod restarted"
              query                = "max(last_8m):sum:kubernetes_state.container.restarts{kube_namespace:default AND (kube_container_name:dp-idbroker OR kube_container_name:rbac-stop-gap)} by {kube_namespace,kube_container_name} >= 2"
              message              = "{{container.name}} restarted in Id broker pod\n"
              critical             = 2
              critical_recovery    = 1
              warning              = null
              warning_recovery     = null
              #priority             = 3
              mon_priority         = {}
              notify               = " "
            }
          ]
        },
        {
          name         = "dcam_api"
          metrics_type = "service"
          tag_ciid = {
            global = "CI116457447"
            us     = "CI116457338"
            au     = "CI116457340"
            eu     = "CI116457342"
            sg     = "CI116457344"
          }

          custom_monitor = [

            {

              enable_namespace_val = true

              namespace_val        = {}

              alert_name           = "Dcam Api Pod restarted"

              query                = "max(last_8m):sum:kubernetes_state.container.restarts{kube_namespace:default AND (kube_container_name:dcam-api)} by {kube_namespace,kube_container_name} >= 2"

              message              = "{{container.name}} restarted in dcam-api pod\n"

              critical             = 2

              critical_recovery    = 1

              warning              = null

              warning_recovery     = null

              #priority             = 3

              mon_priority         = {}

              notify               = " "

            }

          ]

        }        

      ]

    }

  }

}





variable "log_monitors_val" {

  description = "List of log monitors for all teams and their services"

  type        = map(any)

  default = {

    team_2 = {

      team_name = "TEAM_NAME_2"

      services = [   

        {

          name = "fabric-api-v3"

          tag_ciid = {

            global = "CI40696181"

            us     = "CI116457321"

            au     = "CI116457324"

            eu     = "CI116457326"

            sg     = "CI116457328"       

          }

          log_monitor = [

            {

              alert_name        = "fabric-api-v3 Interrupted connection getting response for future"

              query             = "logs(\"service:fabric-api-v3 status:error \\\"Unknown while calling\\\"\").index(\"*\").rollup(\"count\").last(\"5m\") > 5"

              message           = "**\n\n**Env: {{log.tags.env_}}** \n\n**Monitor Alert Message:**\n\n Interrupted connection getting response for future is triggered for {{log.service}} in {{kube_cluster_name.name}} \n Validate in logs which service is being called and test connection \n**Possible Resolution Steps:**\n\n \n**"

              critical          = 5

              critical_recovery = 4.9

              warning           = null

              warning_recovery  = null

              priority          = 1

              notify            = " "

            },

            {

              alert_name        = "fabric-api-v3 Cannot connect getting response for future"

              query             = "logs(\"service:fabric-api-v3 status:error \\\"Unable to connect to\\\"\").index(\"*\").rollup(\"count\").last(\"5m\") > 5"

              message           = "**\n\n**Env: {{log.tags.env_}}** \n\n**Monitor Alert Message:**\n\n Cannot connect getting response for future is triggered for {{log.service}} in {{kube_cluster_name.name}} \n Validate in logs which service is being called and test connection \n**Possible Resolution Steps:**\n\n \n**"

              critical          = 5

              critical_recovery = 4.9

              warning           = null

              warning_recovery  = null

              priority          = 1

              notify            = " "

            },

            {

              alert_name        = "fabric-api-v3 Cannot upload files before containers are provisioned"

              query             = "logs(\"service:fabric-api-v3 status:error \\\"container not provisioned for file upload\\\"\").index(\"*\").rollup(\"count\").last(\"5m\") > 5"

              message           = "**\n\n**Env: {{log.tags.env_}}** \n\n**Monitor Alert Message:**\n\n Cannot upload files before containers are provisioned is triggered for {{log.service}} in {{kube_cluster_name.name}} \n Validate in logs which service is being called and test connection \n**Possible Resolution Steps:**\n\n \n Check if the database is up \n**"

              critical          = 5

              critical_recovery = 4.9

              warning           = null

              warning_recovery  = null

              priority          = 1

              notify            = " "

            }

          ]

        },

        {

          name = "workspace-service"

          tag_ciid = {

            global = ""

            us     = "CI116457421"

            au     = "CI41101427"



            eu     = "CI41101419"

            sg     = "CI58685029"

          }

          log_monitor = [

            {

              alert_name        = "Workspace-service Interrupted connection getting response for future"

              query             = "logs(\"service:workspace-service status:error \\\"Unknown while calling\\\"\").index(\"*\").rollup(\"count\").last(\"5m\") > 5"

              message           = "{service.name} Interrupted connection getting response for future is triggered for {{log.service}} in {{kube_cluster_name.name}} \n Validate in logs which service is being called and test connection \n "

              critical          = 5

              critical_recovery = 4.9

              warning           = null

              warning_recovery  = null

              priority          = 1

              notify            = " "

            },

            {

              alert_name        = "Workspace-service Autz failure"

              query             = "logs(\"service:workspace-service status:error \\\"Errno\\\"\").index(\"*\").rollup(\"count\").last(\"2m\") > 3"

              message           = "{service.name} Autz failure is triggered for {{log.service}} in {{kube_cluster_name.name}} \n Validate user credentials if it's exist \n"

              critical          = 3

              critical_recovery = 2.9

              warning           = null

              warning_recovery  = null

              priority          = 1

              notify            = " "

            },

            {

              alert_name        = "Workspace-service Unable to Create Workspace"

              query             = "logs(\"service:workspace-service status:error \\\"com.pwc.base.exceptions.PwcBaseException\\\"\").index(\"*\").rollup(\"count\").last(\"5m\") > 3"

              message           = "{service.name} Unable to Create Workspace is triggered for {{log.service}} in {{kube_cluster_name.name}} \n Check the logs for reason of unable to create workspace. exc(invalid workspace name, special character)\n "

              critical          = 3

              critical_recovery = 2.9

              warning           = null

              warning_recovery  = null

              priority          = 1

              notify            = " "

            },

            {

              alert_name        = "Workspace-service Unable to get Workspace information"

              query             = "logs(\"service:workspace-service status:error \\\"unable to find workspace\\\"\").index(\"*\").rollup(\"count\").last(\"5m\") > 10"

              message           = " {service.name} Unable to get Workspace information is triggered for {{log.service}} in {{kube_cluster_name.name}} \n validate if workspace has been created  or exist \n"

              critical          = 10

              critical_recovery = 9

              warning           = null

              warning_recovery  = null

              priority          = 1

              notify            = " "

            },

            {

              alert_name        = "Workspace-service Unable to delete Workspace"

              query             = "logs(\"service:workspace-service status:error \\\"org.springframework.core.convert.ConversionFailedException\\\"\").index(\"*\").rollup(\"count\").last(\"10m\") > 3"

              message           = "{service.name} Unable to delete Workspace is triggered for {{log.service}} in {{kube_cluster_name.name}} \n check on the logs for reason to unable to delete the workspace. ex(invalid workspace name)\n"

              critical          = 3

              critical_recovery = 2.9

              warning           = null

              warning_recovery  = null

              priority          = 1

              notify            = " "

            },

            {

              alert_name        = "Workspace-service Unable to connect to Cosmos DB"

              query             = "logs(\"service:workspace-service status:error \\\"Connection failed\\\"\").index(\"*\").rollup(\"count\").last(\"5m\") > 0"

              message           = "{service.name} Unable to connect to Cosmos DB is triggered for {{log.service}} in {{kube_cluster_name.name}} \n check on the logs for reason connection failed. ex(credentials, invalid DB information) \n"

              critical          = 0

              critical_recovery = 0

              warning           = null

              warning_recovery  = null

              priority          = 1

              notify            = " "

            },

            {

              alert_name        = "Workspace-service Unable to update workspace user"

              query             = "logs(\"service:workspace-service status:error \\\"Error dropping the message\\\"\").index(\"*\").rollup(\"count\").last(\"5m\") > 3"

              message           = "{service.name} Unable to update workspace user is triggered for {{log.service}} in {{kube_cluster_name.name}} \n Validate if user existand is using correct credentials \n"

              critical          = 3

              critical_recovery = 2.9

              warning           = null

              warning_recovery  = null

              priority          = 1

              notify            = " "

            },

            {

              alert_name        = "Workspace-service Unable to get workspace users"

              query             = "logs(\"service:workspace-service status:error \\\"unable to get results from Azure Search\\\"\").index(\"*\").rollup(\"count\").last(\"5m\") > 3"

              message           = "{service.name} Unable to get workspace users is triggered for {{log.service}} in {{kube_cluster_name.name}} \n Validate if user existand is using correct credentials \n"

              critical          = 3

              critical_recovery = 2.9

              warning           = null

              warning_recovery  = null

              priority          = 1

              notify            = " "

            }

          ]

        },

        {

          name = "engagement-service-v2"

          tag_ciid = {

            global = "CI116457441"

            us     = "CI116457313"

            au     = "CI116457315"

            eu     = "CI116457317"

            sg     = "CI116457319"

          }

          log_monitor = [

            {

              alert_name        = "engagement-service-v2 Postgres connection failure"

              query             = "logs(\"service:engagement-service-v2 status:error @error.kind:(JDBCConnectionException)\").index(\"*\").rollup(\"count\").last(\"5m\") > 0"

              message           = "**\n\n**Env: {{log.tags.env_}}** \n\n**pwc_territory: {{log.tags.pwc_territory_}}**\n\n**Monitor Alert Message:**\n\n Postgres connection failure alert is triggered for {{log.service}} in {{kube_cluster_name.name}} \n**Possible Resolution Steps:**\n\n Validate credentials used for connecting to postgres\n Check if the database is up \n**"

              critical          = 0

              critical_recovery = 0

              warning           = null

              warning_recovery  = null

              priority          = 2

              notify            = " "

            },

            {

              alert_name        = "engagement-service-v2 Unable to authorize the user"

              query             = "logs(\"service:engagement-service-v2 status:error \\\"does not have access to the service\\\"\").index(\"*\").rollup(\"count\").last(\"1m\") > 50"

              message           = "**\n\n**Env: {{log.tags.env_}}** \n\n**pwc_territory: {{log.tags.pwc_territory_}}**\n\n**Monitor Alert Message:**\n\n Unable to authorize the user alert is triggered for {{log.service}} in {{kube_cluster_name.name}} \n**Possible Resolution Steps:**\n\n run the job User_Access_To_Autz_Services_Deploy to give user access\n**"

              critical          = 50

              critical_recovery = 49

              warning           = null

              warning_recovery  = null

              priority          = 2

              notify            = " "

            },

            {

              alert_name        = "engagement-service-v2 Request for non-existent resource"

              query             = "logs(\"service:engagement-service-v2 status:error \\\"No Resources found for\\\"\").index(\"*\").rollup(\"count\").last(\"5m\") > 50"

              message           = "**\n\n**Env: {{log.tags.env_}}** \n\n**pwc_territory: {{log.tags.pwc_territory_}}**\n\n**Monitor Alert Message:**\n\n Request for non-existent resource alert is triggered for {{log.service}} in {{kube_cluster_name.name}} \n**Possible Resolution Steps:**\n\n Need to manually examine logs to determine a potential problem \n**"

              critical          = 50

              critical_recovery = 49

              warning           = null

              warning_recovery  = null

              priority          = 2

              notify            = " "

            },



          ]

        },

        {

          name = "generic-kafka-producer"

          tag_ciid = {

            global = "CI40696181"

            us = "CI116457330"

            au = "CI116457332"

            eu = "CI116457334"

            sg = "CI116457336"        

          }

          log_monitor = [

            {

              alert_name        = "generic-kafka-producer No active Kafka Nodes Instances found"

              query             = "logs(\"service:generic-kafka-producer status:error \\\"There are no Kafka Brokers UP for Cluster\\\"\").index(\"*\").rollup(\"count\").last(\"2m\") > 0"

              message           = "**\n\n**Env: {{log.tags.env_}}** \n\n**pwc_territory: {{log.tags.pwc_territory_}}**\n\n**Monitor Alert Message:**\n\n No active Kafka Nodes Instances found alert is triggered for {{log.service}} in {{kube_cluster_name.name}} \n\n**Possible Resolution Steps:**\n\n Check if kafka cluster is up and healthy\n Check the KAFKA_BOOTSTRAP_SERVERS property to get the instances and verify they are up and running \n**"

              critical          = 0

              critical_recovery = 0

              warning           = null

              warning_recovery  = null

              priority          = 4

              notify            = " "

            },

            {

              alert_name        = "generic-kafka-producer Kafka connect Timeout"

              query             = "logs(\"service:generic-kafka-producer status:error \\\"service is taking more than\\\"\").index(\"*\").rollup(\"count\").last(\"2m\") > 0"

              message           = "**\n\n**Env: {{log.tags.env_}}** \n\n**pwc_territory: {{log.tags.pwc_territory_}}**\n\n**Monitor Alert Message:**\n\n Kafka connect Timeout alert is triggered for {{log.service}} in {{kube_cluster_name.name}} \n\n**Possible Resolution Steps:**\n\n Validate credentials used for connecting to Kafka Cluster \n**"

              critical          = 0

              critical_recovery = 0

              warning           = null

              warning_recovery  = null

              priority          = 4

              notify            = " "

            },

            {

              alert_name        = "generic-kafka-producer Kafka Failed Server Error"

              query             = "logs(\"service:generic-kafka-producer status:error \\\"unable to connect to kafka\\\"\").index(\"*\").rollup(\"count\").last(\"2m\") > 0"

              message           = "**\n\n**Env: {{log.tags.env_}}** \n\n**pwc_territory: {{log.tags.pwc_territory_}}**\n\n**Monitor Alert Message:**\n\n Kafka Failed Server Error alert is triggered for {{log.service}} in {{kube_cluster_name.name}} \n\n**Possible Resolution Steps:**\n\n Validate credentials used for connecting to Kafka Cluster\n Check the KAFKA_BOOTSTRAP_SERVERS property to get the instances and verify they are up and running \n**"

              critical          = 0

              critical_recovery = 0

              warning           = null

              warning_recovery  = null

              priority          = 4

              notify            = " "

            },

            {

              alert_name        = "generic-kafka-producer Kafka unable to drop message in kafka with Topic"

              query             = "logs(\"service:generic-kafka-producer status:error \\\"unable to drop message in kafka Topic\\\"\").index(\"*\").rollup(\"count\").last(\"2m\") > 5"

              message           = "**\n\n**Env: {{log.tags.env_}}** \n\n**pwc_territory: {{log.tags.pwc_territory_}}**\n\n**Monitor Alert Message:**\n\n Kafka unable to drop message in kafka with Topic alert is triggered for {{log.service}} in {{kube_cluster_name.name}} \n\n**Possible Resolution Steps:**\n\n Need to manually examine logs to determine a potential problem in callers message resulting in failure \n**"

              critical          = 5

              critical_recovery = 4.9

              warning           = null

              warning_recovery  = null

              priority          = 4

              notify            = " "

            },

            {

              alert_name        = "generic-kafka-producer Error Dropping Message"

              query             = "logs(\"service:generic-kafka-producer status:error \\\"failed dropping a message into the kafka topic\\\"\").index(\"*\").rollup(\"count\").last(\"2m\") > 5"

              message           = "**\n\n**Env: {{log.tags.env_}}** \n\n**pwc_territory: {{log.tags.pwc_territory_}}**\n\n**Monitor Alert Message:**\n\n Error Dropping Message alert is triggered for {{log.service}} in {{kube_cluster_name.name}} \n\n**Possible Resolution Steps:**\n\n Need to manually examine logs to determine a potential problem in callers message resulting in failure \n**"

              critical          = 5

              critical_recovery = 4.9

              warning           = null

              warning_recovery  = null

              priority          = 4

              notify            = " "

            },

          ]

        },

        {

          name = "ms-teams-wrapper"

          tag_ciid = {

            global = "CI116457421"

            us     = "CI116457421"

            au     = "CI41101427"

            eu     = "CI41101419"

            sg     = "CI58685029"

          }

          log_monitor = [         

            {

              alert_name        = "MS Teams Pod error"

              query             = "logs(\"service:ms-teams-wrapper \\\"Timed out MetadataRequest in flight\\\"\").index(\"*\").rollup(\"count\").by(\"env\").last(\"5m\") > 1"

              message           = "MS Teams Pod error in **\n\n**Env: {{log.tags.env_}}**. Please restart the faulty pod. Cluster:{{cluster_name.name}}  POD:{{pod_name.name}}"

              critical          = 1

              critical_recovery = 0.9

              warning           = null

              warning_recovery  = null

              priority          = 2

              notify            = " "

            },

            {

              alert_name        = "MS Teams Application maximum poll interval"

              query             = "logs(\"service:ms-teams-wrapper \\\"Application maximum poll interval\\\"\").index(\"*\").rollup(\"count\").by(\"env\").last(\"5m\") > 1"

              message           = "MS Teams Application maximum poll interval in **\n\n**Env: {{log.tags.env_}}**. Please restart the service. Cluster:{{cluster_name.name}}  POD:{{pod_name.name}}"

              critical          = 1

              critical_recovery = 0.9

              warning           = null

              warning_recovery  = null

              priority          = 2

              notify            = " "

            }

          ]






