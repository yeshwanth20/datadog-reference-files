#version:1
# This is a sanitized template file for reference purposes only
# Replace all placeholder values with actual service configurations

variable "regions_envs" {
  type= any
  default =  [
    { location = "<region_1>", env = "<environment>", scope = "deploy", create_test = true, create_monitor = true, create_slo = true, create_her_monitor = true },
    { location = "<region_2>", env = "<environment>", scope = "green", create_test = true, create_monitor = true, create_slo = true, create_her_monitor = true},
    { location = "<region_3>", env = "<environment>", scope = "deploy", create_test = true, create_monitor = true, create_slo = true, create_her_monitor = true },
    { location = "<region_4>", env = "<environment>", scope = "deploy", create_test = true, create_monitor = true, create_slo = true, create_her_monitor = true },
    # Example: { location = "us", env = "prod", scope = "deploy", create_test = true, create_monitor = true, create_slo = true, create_her_monitor = true }
  ]
}

variable "nifi_prov_regions_envs" {
  type= any
  default =  [
    { location = "<region_1>", env = "<environment>", scope = "deploy", create_test = true, create_monitor = true, create_slo = true },
    { location = "<region_2>", env = "<environment>", scope = "green", create_test = true, create_monitor = true, create_slo = true },
    { location = "<region_3>", env = "<environment>", scope = "deploy", create_test = true, create_monitor = true, create_slo = true },
    { location = "<region_4>", env = "<environment>", scope = "deploy", create_test = true, create_monitor = true, create_slo = true },
    # Example: { location = "eu", env = "prod", scope = "deploy", create_test = true, create_monitor = true, create_slo = true }
  ]
}

variable "regions_envs_team" {
  type= any
  default =  [
    { location = "<region_1>", env = "<environment>", scope = "deploy", create_test = true, create_monitor = true, create_slo = true },
    { location = "<region_2>", env = "<environment>", scope = "green", create_test = true, create_monitor = true, create_slo = true },
    { location = "<region_3>", env = "<environment>", scope = "deploy", create_test = true, create_monitor = true, create_slo = true },
    { location = "<region_4>", env = "<environment>", scope = "deploy", create_test = true, create_monitor = true, create_slo = true },
    # Example: { location = "ap", env = "prod", scope = "deploy", create_test = true, create_monitor = true, create_slo = true }
  ]
}

variable "exclude_teams_monitor" {
  default = {
    "<region_1>_<env>" = [
      "<frontend_service>",
      "<container_operations>"
    ]
    "<region_2>_<env>" = [ 
      "<frontend_service>",
      "<container_operations>",
      "<data_visualization_service>"
    ]
    "<region_3>_<env>" = [   
      "<frontend_service>",
      "<container_operations>",
      "<data_visualization_service>",
      "<analytics_api>"
    ]
    "<region_4>_<env>" = [
      "<legacy_services_api>",
      "<platform_node_api>",
      "<frontend_service>",
      "<analytics_service>",
      "<container_operations>",
      "<data_flow_viz_service>",
      "<notification_service>",
      "<data_extraction_service>",
      "<data_visualization_service>",
      "<insights_service>"
    ]
    # Example:
    # "us_prod" = [
    #   "web-frontend",
    #   "docker-operations"
    # ]
  }
}

variable "exclude_teams_critical_monitor" {
  default = {
    "<region_1>_<env>" = [
      "<frontend_service>",
      "<container_operations>",
      "<command_api>",
      "<query_api>",
      "<approval_service>",
      "<analytics_api>",
      "<reporting_service>"
    ]
    "<region_2>_<env>" = [  
      "<frontend_service>",
      "<dns_service>",
      "<container_operations>",
      "<command_api>",
      "<management_api>",
      "<approval_service>",
      "<analytics_api>"      

    ]
    "<region_3>_<env>" = [    
      "<frontend_service>",
      "<dns_service>",
      "<container_operations>",
      "<notification_service>",
      "<consolidation_service>",
      "<approval_service>",
      "<analytics_api>"

    ]
    "<region_4>_<env>" = [
      "<legacy_services_api>",      
      "<platform_node_api>",
      "<frontend_service>",
      "<dns_service>",
      "<analytics_service>",
      "<container_operations>",
      "<data_flow_viz_service>",
      "<data_extraction_service>",
      "<reporting_service>",
      "<notification_service>",
      "<consolidation_service>",
      "<management_api>",  
      "<business_intelligence>",
      "<insights_service>",
      "<approval_service>",
      "<analytics_api>"
      
    ]
    # Example:
    # "us_prod" = [
    #   "web-frontend",
    #   "docker-operations",
    #   "visualization-command-api",
    #   "visualization-query-api",
    #   "workflow-approval-service",
    #   "data-analytics-api",
    #   "tableau-service"
    # ]
  }
}

variable "exclude_log_monitor" {
  default = {
    "<region_1>_<env>" = [
      "<database_service>",
    ]
    "<region_2>_<env>" = [
      "<database_service>",
      "<security_service>"
    ]
    "<region_3>_<env>" = [
      "<database_service>",
      "<security_service>"  
    ]
    "<region_4>_<env>" = [
      "<event_replication_service>",
      "<database_service>",
      "<provisioning_request_service>",
      "<management_api>",
      "<security_service>"
    ]
    # Example:
    # "us_prod" = [
    #   "postgres-service"
    # ]
  }
}

variable "exclude_cdf_nifi_log_monitor" {
  default = {
    "<region_1>_<env>" = []
    "<region_2>_<env>" = []
    "<region_3>_<env>" = []
    "<region_4>_<env>" = []
    # Example: Add service names to exclude from data flow log monitoring
    # "us_prod" = ["<data_processing_service>"]
  }
}
variable "exclude_heap_monitor_val" {
  default = {
    "<region_1>_<env>" = [
      "<insights_service>",
      "<business_intelligence_service>"
    ]
    "<region_2>_<env>" = [
      "<insights_service>",
      "<business_intelligence_service>"
    ]
    "<region_3>_<env>" = [
      "<insights_service>",
      "<business_intelligence_service>"
    ]
    "<region_4>_<env>" = [
      "<insights_service>",
      "<business_intelligence_service>"
    ]
    # Example:
    # "us_prod" = [
    #   "analytics-insights",
    #   "reporting-service"
    # ]
  }  
}

variable "exclude_cpu_monitor_val" {
  default = {
    "<region_1>_<env>" = []
    "<region_2>_<env>" = []
    "<region_3>_<env>" = [
      "<analytics_api>"
    ]
    "<region_4>_<env>" = []
    # Example:
    # "au_prod" = [
    #   "data-analysis-api"
    # ]
  }  
}

variable "exclude_synthetics_monitors_custom_val" {
  default = {
    "<region_1>_<env>" = [
      # Add synthetic monitor names to exclude
    ]
    "<region_2>_<env>" = [
      "<monitoring_service>"     
    ]
    "<region_3>_<env>" = [
      "<monitoring_service>"
    ]
    "<region_4>_<env>" = [
      "<orchestration_platform_1>",
      "<orchestration_platform_2>",
      "<search_security_service>",
      "<event_replication_service>",
      "<analytics_platform_service>",
      "<service_handlers>",
      "<monitoring_service>"
    ]
    # Example:
    # "sg_prod" = [
    #   "kubernetes-cluster-manager",
    #   "kubernetes-registry",
    #   "elasticsearch-security",
    #   "event-replication",
    #   "databricks-integration",
    #   "request-handlers",
    #   "metrics-dashboard"
    # ]
  }
}

variable "exclude_nifi_service_prov_monitor_val"{
  default = {
    "<region_1>_<env>" = [
      # Add service provisioning patterns to exclude
    ]
    "<region_2>_<env>" = [
      # Add service provisioning patterns to exclude
    ]
    "<region_3>_<env>" = [
      # Add service provisioning patterns to exclude

    ]
    "<region_4>_<env>" = [
      # Add service provisioning patterns to exclude
    ]
    # Example:
    # "eu_prod" = [
    #   "provisioning-prereq-*"
    # ]
  }
}

variable "exclude_nifi_metric_monitor_val" {
  default = {
    "<region_1>_<env>" = [
      "<file_processing_service>",
      "<asset_management_service>",
      "<data_extraction_service>",
      "<asset_management_service>"     
    ]
    "<region_2>_<env>" = [
      "<file_processing_service>",
      "<data_factory_operations>",
      "<asset_management_service>",
      "<data_extraction_service>",
      "<asset_management_service>"
    ]
    "<region_3>_<env>" = [
      "<file_processing_service>",
      "<data_factory_operations>",
      "<asset_management_service>",
      "<data_extraction_service>",
      "<asset_management_service>"     
    ]
    "<region_4>_<env>" = [
      "<service_handlers>",
      "<event_replication_service>",
      "<message_consumer_service>",
      "<file_processing_service>",
      "<data_factory_operations>",
      "<asset_management_service>",
      "<asset_deletion_service>",
      "<asset_management_service>" 
    ]
    # Example:
    # "us_prod" = [
    #   "compression-service",
    #   "workspace-asset-manager",
    #   "etl-extract-service",
    #   "workspace-asset-manager"
    # ]
  }
}

variable "exclude_custom_monitor_val" {
  default = {
    "<region_1>_<env>" = [
      "<Data_Flow_Service> AAD Management Group Creation Failed",
      "<Data_Flow_Service> AAD Management Content PVC Critical",
      "<Data_Flow_Service> AAD Management FlowFile PVC Critical",
      "<Data_Flow_Service> AAD Management Provenance PVC Critical",
      "<Data_Flow_Service> Workspace Management Content PVC Critical",
      "<Data_Flow_Service> Workspace Management FlowFile PVC Critical",
      "<Data_Flow_Service> Workspace Management Provenance PVC Critical",
      "<Data_Flow_Service> Workspace Management Flowfile Retry Failure",
      "<Data_Flow_Service> Workspace Management Statefulset is Down",
      "<Data_Flow_Service> Workspace ManagementFailure",
      "<Data_Flow_Service> Workspace Migration Content PVC Critical",
      "<Data_Flow_Service> Workspace Migration FlowFile PVC Critical",
      "<Data_Flow_Service> Workspace Migration Provenance PVC Critical",
      "<Data_Flow_Service> Workspace Migration Flowfile Retry Failure"
    ]
    "<region_2>_<env>" = [
      "<Data_Flow_Service> AAD Management Group Creation Failed",
      "<Data_Flow_Service> AAD Management Content PVC Critical",
      "<Data_Flow_Service> AAD Management FlowFile PVC Critical",
      "<Data_Flow_Service> AAD Management Provenance PVC Critical",
      "<Data_Flow_Service> Workspace Management Statefulset is Down",
      "<Data_Flow_Service> Workspace Management Content PVC Critical",
      "<Data_Flow_Service> Workspace Management FlowFile PVC Critical",
      "<Data_Flow_Service> Workspace Management Provenance PVC Critical",
      "<Data_Flow_Service> Workspace Management Flowfile Retry Failure",
      "<Data_Flow_Service> Workspace Management Statefulset is Down",
      "<Data_Flow_Service> Workspace ManagementFailure",
      "<Data_Flow_Service> Workspace Migration Content PVC Critical",
      "<Data_Flow_Service> Workspace Migration FlowFile PVC Critical",
      "<Data_Flow_Service> Workspace Migration Provenance PVC Critical",
      "<Data_Flow_Service> Workspace Migration Flowfile Retry Failure"
    ]
    "<region_3>_<env>" = [
      "<Data_Flow_Service> AAD Management Group Creation Failed",
      "<Data_Flow_Service> AAD Management Content PVC Critical",
      "<Data_Flow_Service> AAD Management FlowFile PVC Critical",
      "<Data_Flow_Service> AAD Management Provenance PVC Critical",
      "<Data_Flow_Service> Workspace Management Statefulset is Down",
      "<Data_Flow_Service> Workspace Management Content PVC Critical",
      "<Data_Flow_Service> Workspace Management FlowFile PVC Critical",
      "<Data_Flow_Service> Workspace Management Provenance PVC Critical",
      "<Data_Flow_Service> Workspace Management Flowfile Retry Failure",
      "<Data_Flow_Service> Workspace Management Statefulset is Down",
      "<Data_Flow_Service> Workspace ManagementFailure",
      "<Data_Flow_Service> Workspace Migration Content PVC Critical",
      "<Data_Flow_Service> Workspace Migration FlowFile PVC Critical",
      "<Data_Flow_Service> Workspace Migration Provenance PVC Critical",
      "<Data_Flow_Service> Workspace Migration Flowfile Retry Failure",
      "<Analytics_Api> Pod restarted"
    ]
    "<region_4>_<env>" = [
      "<Data_Flow_Service> AAD Management Statefulset Is Down",
      "<Data_Flow_Service> Workspace Management Statefulset is Down",
      "<Data_Flow_Service> AAD Management Statefulset Is Down",
      "<Data_Flow_Service> Workspace Management Content PVC Critical",
      "<Data_Flow_Service> Workspace Management FlowFile PVC Critical",
      "<Data_Flow_Service> Workspace Management Provenance PVC Critical",
      "<Data_Flow_Service> Workspace Management Flowfile Retry Failure",
      "<Data_Flow_Service> Workspace Management Statefulset is Down",
      "<Data_Flow_Service> Workspace ManagementFailure",
      "<Data_Flow_Service> Workspace Migration Content PVC Critical",
      "<Data_Flow_Service> Workspace Migration FlowFile PVC Critical",
      "<Data_Flow_Service> Workspace Migration Provenance PVC Critical",
      "<Data_Flow_Service> Workspace Migration Flowfile Retry Failure"
    ]
    # Example monitor names:
    # "us_prod" = [
    #   "Apache_NiFi AAD Management Group Creation Failed",
    #   "Apache_NiFi AAD Management Content PVC Critical",
    #   "Apache_NiFi Workspace Management Flowfile Retry Failure",
    #   "Data_Analytics_Api Pod restarted"
    # ]
  }  
}

variable "exclude_kube_monitors" {
  default = {
    "<region_1>_<env>" = []
    "<region_2>_<env>" = []
    "<region_3>_<env>" = []
    "<region_4>_<env>" = []
    # Example: Add Kubernetes monitor names to exclude
    # "us_prod" = ["<k8s_monitor_name>"]
  }  
}

variable "exclude_team_kube_monitors" {
  default = {
    "<region_1>_<env>" = []
    "<region_2>_<env>" = []
    "<region_3>_<env>" = [
      "<TEAM_NAME_A>_service_<Analytics_Api> Kubernetes Memory Usage above threshold"
    ]
    "<region_4>_<env>" = []
    # Example:
    # "au_prod" = [
    #   "DataTeam_service_Analytics-Api Kubernetes Memory Usage above threshold"
    # ]
  }  
}

variable "exclude_paas_monitors_val" {
  default = {
    "<region_1>_<env>" = []
    "<region_2>_<env>" = []
    "<region_3>_<env>" = []
    "<region_4>_<env>" = []
    # Example: Add PaaS service names to exclude from monitoring
    # "us_prod" = ["<paas_service_1>", "<paas_service_2>"]
  }  
}

variable "critical_slo_custom" {
  default = {
    "<region_1>_<env>" = [
      "<admin_service>",
      "<platform_node_api>",
      # "<analytics_frontend>",
      "<authorization_service>",
      "<content_service>",
      "<gallery_service>",
      "<frontend_services>",
      "<pages_service>",
      "<sites_service>",
      "<collaboration_wrapper>",
      "<fabric_api_v3>",
      "<engagement_service_v2>",
      "<catalogue_service_v3>",
      "<context_adapter_service>",
      "<data_api>",
      "<user_directory_service>",
      "<app_configuration_service>",
    ]
    "<region_2>_<env>" = [
      "<admin_service>",
      "<platform_node_api>",
      # "<analytics_frontend>",
      "<authorization_service>",
      "<content_service>",
      "<gallery_service>",
      "<frontend_services>",
      "<pages_service>",
      "<sites_service>",
      "<collaboration_wrapper>",
      "<fabric_api_v3>",
      "<engagement_service_v2>",
      "<catalogue_service_v3>",
      "<data_visualization_service>",
      "<context_adapter_service>",
      "<data_api>",
      "<user_directory_service>",
      "<app_configuration_service>",
    ]
    "<region_3>_<env>" = [
      "<admin_service>",
      "<platform_node_api>",
      "<collaboration_wrapper>",
      "<fabric_api_v3>",
      "<engagement_service_v2>",
      "<catalogue_service_v3>",
      "<data_visualization_service>",
      # "<analytics_frontend>",
      "<authorization_service>",
      "<content_service>",
      "<gallery_service>",
      "<frontend_services>",
      "<pages_service>",
      "<sites_service>",
      "<context_adapter_service>",
      "<data_api>",
      "<user_directory_service>",
      "<app_configuration_service>",
    ]
    "<region_4>_<env>" = [
      "<admin_service>",
      # "<analytics_frontend>",
      "<authorization_service>",
      "<content_service>",
      "<gallery_service>",
      "<frontend_services>",
      "<pages_service>",
      "<sites_service>",
      "<collaboration_wrapper>",
      "<fabric_api_v3>",
      "<engagement_service_v2>",
      "<catalogue_service_v3>",
      "<data_visualization_service>",
      "<context_adapter_service>",
      "<data_api>",
      "<user_directory_service>",
      "<app_configuration_service>",
    ]
    # Example:
    # "us_prod" = [
    #   "django-project-admin",
    #   "Portal Node API",
    #   # "Web Analytics Frontend",
    #   "Authentication Service",
    #   "Content Management Service",
    #   "Image Gallery Service",
    #   "React Frontend Services",
    #   "CMS Pages Service",
    #   "Sites Management Service",
    #   "slack-integration-wrapper",
    #   "platform api v3",
    #   "project service v2",
    #   "catalog service v3",
    #   "Dashboard Analytics Service",
    #   "Workspace Context Adapter",
    #   "User Data API",
    #   "User Management Service",
    #   "Application Config Service"
    # ]
  }  
}

variable "legacy_services" {
  default = {
    "<region_1>_<env>" = []
    "<region_2>_<env>" = []
    "<region_3>_<env>" = []
    "<region_4>_<env>" = []
    # Example:
    # "us_prod" = [
    #   "Legacy_Platform_Services_api"
    # ]
  }
  
}

variable "exclude_service_infra_monitors" {
  default = {
    "<region_1>_<env>" = [
      "service_Pod restart in cluster greater than 3",
      "service_Pods Restarting",
      "service_Deployments Replica Pods",
      "service_Pod is ImagePullBackOff",
      "service_Pod is CrashloopBackOff",
    ]
    "<region_2>_<env>" = [
      "service_Pod restart in cluster greater than 3",
      "service_Pods Restarting",
      "service_Deployments Replica Pods",
      "service_Pod is ImagePullBackOff",
      "service_Pod is CrashloopBackOff",
    ]
    "<region_3>_<env>" = [
      "service_Pod restart in cluster greater than 3",
      "service_Pods Restarting",
      "service_Deployments Replica Pods",
      "service_Pod is ImagePullBackOff",
      "service_Pod is CrashloopBackOff",
    ]
    "<region_4>_<env>" = [
      "service_Pod restart in cluster greater than 3",
      "service_Pods Restarting",
      "service_Deployments Replica Pods",
      "service_Pod is ImagePullBackOff",
      "service_Pod is CrashloopBackOff",
    ]
    # Example: These are standard Kubernetes infrastructure monitor patterns
    # that can be excluded for specific services or environments
  } 
}

variable "service_name" {
  default = {
    team_alpha = {
      team_name = "TEAM_NAME_ALPHA"
      services = [
        {
          name        = "service-api-v3"
          tag_ciid = {
            us     = "CI000000001"
            au     = "CI000000002"
            eu     = "CI000000003"
            sg     = "CI000000004"  
          }
        },
      ]
    },
    team_beta = {
      team_name = "TEAM_NAME_BETA"
      services = [
        {
          name        = "catalog-service-v3"
          tag_ciid = {
            us = "CI000000005"
            au = "CI000000006"
  