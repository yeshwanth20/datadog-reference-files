#version:1
# This is a sanitized template file for reference purposes only
# Replace all placeholder values with actual service configurations

variable "regions_envs" {
  type    = any
  default =  [
    { location = "<region_1>", env = "<environment>", scope = "deploy", create_test = true, create_monitor = true, create_slo = true, create_her_monitor = true },
    { location = "<region_2>", env = "<environment>", scope = "deploy", create_test = true, create_monitor = true, create_slo = true, create_her_monitor = true }
    # Example: { location = "us", env = "prod", scope = "deploy", create_test = true, create_monitor = true, create_slo = true, create_her_monitor = true }
  ]
}

variable "nifi_prov_regions_envs" {
  type    = any
  default =  [
    { location = "<region_1>", env = "<environment>", scope = "deploy", create_test = true, create_monitor = true, create_slo = true },
    { location = "<region_2>", env = "<environment>", scope = "deploy", create_test = true, create_monitor = true, create_slo = true }
    # Example: { location = "eu", env = "prod", scope = "deploy", create_test = true, create_monitor = true, create_slo = true }
  ]
}

variable "regions_envs_team" {
  type    = any
  default =  [    
    { location = "<region_1>", env = "<environment>", scope = "deploy", create_test = true, create_monitor = true, create_slo = true },
    { location = "<region_2>", env = "<environment>", scope = "deploy", create_test = true, create_monitor = true, create_slo = true }
    # Example: { location = "ap", env = "dev", scope = "deploy", create_test = true, create_monitor = true, create_slo = true }
  ]
}

variable "exclude_teams_monitor" {
  default = {
    "<region_1>_<env>" = [
      "<service_name_1>",
      "<service_name_2>"
    ]
    "<region_2>_<env>" = [
      "<service_name_1>",
      "<service_name_2>"      
    ]
    # Example:
    # "us_prod" = [
    #   "frontend-service",
    #   "analytics-dashboard"
    # ]
  }
}

variable "exclude_teams_critical_monitor" {
  default = {
    "<region_1>_<env>" = [
      "<service_name_1>",
      "<service_name_2>",
      "<notification_service>",
      "<consolidation_service>",
      "<approval_service>",
      "<api_service>",
      "<analytics_service>"     
    ]
    "<region_2>_<env>" = [
      "<service_name_1>",
      "<service_name_2>",
      "<notification_service>",
      "<command_api>",
      "<management_api>",
      "<query_api>",
      "<approval_service>",
      "<api_service>"      
    ]
    # Example:
    # "us_prod" = [
    #   "web-frontend",
    #   "data-processor",
    #   "email-notifications",
    #   "workflow-consolidation",
    #   "approval-workflow-service",
    #   "core-api",
    #   "reporting-service"
    # ]
  }
}

variable "exclude_log_monitor" {
  default = {
    "<region_1>_<env>" = [
      "<database_service>",
      "<management_api>",
      "<security_service>"
    ]
    "<region_2>_<env>" = [
      "<database_service>",
      "<management_api>",
      "<security_service>"
    ]
    # Example:
    # "us_prod" = [
    #   "postgres-service",
    #   "admin-management-api",
    #   "auth-sentry"
    # ]
  }
}

variable "exclude_cdf_nifi_log_monitor" {
  default = {
    "<region_1>_<env>" = []
    "<region_2>_<env>" = []
    # Example: Add service names to exclude from data flow log monitoring
    # "us_prod" = ["<data_processing_service>"]
  }
}

variable "exclude_heap_monitor_val" {
  default = {
    "<region_1>_<env>" = []
    "<region_2>_<env>" = []
    # Example: Add service names to exclude from heap memory monitoring
    # "eu_prod" = ["<memory_intensive_service>"]
  }  
}

variable "exclude_cpu_monitor_val" {
  default = {
    "<region_1>_<env>" = [
      "<api_service>"
    ]
    "<region_2>_<env>" = [
      "<api_service>"
    ]
    # Example:
    # "us_prod" = [
    #   "data-analysis-api"
    # ]
  }  
}

variable "exclude_synthetics_monitors_custom_val" {
  default = {
    "<region_1>_<env>" = [
      "<orchestration_platform>"
    ]
    "<region_2>_<env>" = [
      "<monitoring_service>",
      "<orchestration_platform>",
    ]
    # Example:
    # "us_prod" = [
    #   "kubernetes-cluster-manager"
    # ]
    # "eu_prod" = [
    #   "metrics-dashboard",
    #   "kubernetes-cluster-manager"
    # ]
  }
}

variable "exclude_nifi_service_prov_monitor_val"{
  default = {
    "<region_1>_<env>" = [
      # Add service provisioning patterns to exclude
    ]
    "<region_2>_<env>" = [
      "<service_provisioning_pattern>-*"
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
      "<event_sync_service>",
      "<asset_management_service>",
      "<data_extraction_service>",
      "<asset_management_service>",
      "<analytics_service>",
      "<container_operations>"    
    ]
    "<region_2>_<env>" = [
      "<file_processing_service>",
      "<data_factory_operations>",
      "<event_sync_service>",
      "<asset_deletion_service>",
      "<data_extraction_service>",
      "<analytics_service>",
      "<container_operations>"     
    ]
    # Example:
    # "us_prod" = [
    #   "compression-service",
    #   "metadata-sync-service",
    #   "workspace-manager",
    #   "etl-extract-service",
    #   "workspace-manager",
    #   "business-analytics",
    #   "docker-operations"
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
      "<Data_Flow_Service> Workspace Management Statefulset is Down",
      "<Data_Flow_Service> Workspace Migration Content PVC Critical",
      "<Data_Flow_Service> Workspace Migration FlowFile PVC Critical",
      "<Data_Flow_Service> Workspace Migration Provenance PVC Critical",
      "<Data_Flow_Service> Workspace Migration Flowfile Retry Failure", 
      "<Data_Flow_Service> Workspace Management Content PVC Critical",
      "<Data_Flow_Service> Workspace Management FlowFile PVC Critical",
      "<Data_Flow_Service> Workspace Management Flowfile Retry Failure",
      "<Data_Flow_Service> Workspace Management Statefulset is Down" ,
      "<Data_Flow_Service> Workspace ManagementFailure",
      "<Data_Flow_Service> Workspace Migration Content PVC Critical",
      "<Data_Flow_Service> Workspace Migration FlowFile PVC Critical",
      "<Data_Flow_Service> Workspace Migration Provenance PVC Critical",
      "<Data_Flow_Service> Workspace Migration Flowfile Retry Failure",
      "<Data_Flow_Service> Content PVC",
      "<Data_Flow_Service> Flowfile PVC",
      "<Data_Flow_Service> Provenance PVC",
      "<Data_Flow_Service> nodes Statefulset is Down",
      "<Data_Flow_Service>-Registry Statefulset is Down",
      "<Security_Service> <Search_Service> <Data_Flow_Service> AKS Statefulset is Down",
      "<Coordination_Service> Statefulset is Down",
      "<Analytics_Api> Pod restarted"
    ]
    "<region_2>_<env>" = [
      "<Data_Flow_Service> AAD Management Group Creation Failed",
      "<Data_Flow_Service> AAD Management Content PVC Critical",
      "<Data_Flow_Service> AAD Management FlowFile PVC Critical",
      "<Data_Flow_Service> AAD Management Provenance PVC Critical",
      "<Data_Flow_Service> Workspace Management Statefulset is Down",
      "<Data_Flow_Service> Workspace Migration Content PVC Critical",
      "<Data_Flow_Service> Workspace Migration FlowFile PVC Critical",
      "<Data_Flow_Service> Workspace Migration Provenance PVC Critical",
      "<Data_Flow_Service> Workspace Migration Flowfile Retry Failure",
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
      "<Data_Flow_Service> Flowfile PVC",
      "<Data_Flow_Service> Provenance PVC",
      "<Data_Flow_Service> nodes Statefulset is Down",
      "<Data_Flow_Service>-Registry Statefulset is Down",
      "<Security_Service> <Search_Service> <Data_Flow_Service> AKS Statefulset is Down",
      "<Coordination_Service> Statefulset is Down",
      "<Analytics_Api> Pod restarted"
    ]
    # Example monitor names:
    # "us_prod" = [
    #   "Apache_NiFi AAD Management Group Creation Failed",
    #   "Apache_NiFi AAD Management Content PVC Critical",
    #   "Apache_NiFi Workspace Migration Flowfile Retry Failure",
    #   "Ranger Solr Apache_NiFi AKS Statefulset is Down",
    #   "Zookeeper Statefulset is Down",
    #   "Data_Analytics_Api Pod restarted"
    # ]
  }
}

variable "exclude_team_kube_monitors" {
  default = {
    "<region_1>_<env>" = [
      "<TEAM_NAME_A>_service_<Api_Service> Kubernetes Memory Usage above threshold"
    ]
    "<region_2>_<env>" = [
      "<TEAM_NAME_B>_service_Pod restart in cluster greater than 3",
      "<TEAM_NAME_B>_service_Kubernetes Memory Usage above threshold",
      "<TEAM_NAME_A>_service_<Api_Service> Kubernetes Memory Usage above threshold"
    ]
    # Example:
    # "us_prod" = [
    #   "DataTeam_service_Analytics-Api Kubernetes Memory Usage above threshold"
    # ]
    # "eu_prod" = [
    #   "PlatformTeam_service_Pod restart in cluster greater than 3",
    #   "PlatformTeam_service_Kubernetes Memory Usage above threshold",
    #   "DataTeam_service_Analytics-Api Kubernetes Memory Usage above threshold"
    # ]
  }  
}
variable "exclude_paas_monitors_val" {
  default = {
    "<region_1>_<env>" = []
    "<region_2>_<env>" = []
    # Example: Add PaaS service names to exclude from monitoring
    # "us_prod" = ["<paas_service_1>", "<paas_service_2>"]
  }  
}

variable "critical_slo_custom" {
  default = {
    "<region_1>_<env>" = [
      "<Platform_Node_API>",
      "<admin_service>",
      # "<Analytics_Frontend>",
      "<Authorization_Service>",
      "<Content_Service>",
      "<Gallery_Service>",
      "<Frontend_Services>",
      "<Pages_Service>",
      "<Sites_Service>",
      "<collaboration_wrapper>",
      "<fabric_api_v3>",
      "<engagement_service_v2>",
      "<catalogue_service_v3>",
      "<Data_Visualization_Service>",
      "<Context_Adapter_Service>",
      "<Data_API>",
      "<User_Directory_Service>",
      "<App_Configuration_Service>",
    ]
    "<region_2>_<env>" = [
      "<Platform_Node_API>",
      "<admin_service>",
      # "<Analytics_Frontend>",
      "<Authorization_Service>",
      "<Content_Service>",
      "<Gallery_Service>",
      "<Frontend_Services>",
      "<Pages_Service>",
      "<Sites_Service>",
      "<collaboration_wrapper>",
      "<fabric_api_v3>",
      "<engagement_service_v2>",
      "<catalogue_service_v3>",
      "<Data_Visualization_Service>",
      "<Context_Adapter_Service>",
      "<Data_API>",
      "<User_Directory_Service>",
      "<App_Configuration_Service>",
    ]
    # Example:
    # "us_prod" = [
    #   "Portal Node API",
    #   "django-project-admin",
    #   "Web Authorization",
    #   "Content Management Service",
    #   "Image Gallery Service",
    #   "React Frontend Services",
    #   "CMS Pages Service",
    #   "Sites Management Service",
    #   "slack-integration-wrapper",
    #   "platform api v3",
    #   "project service v2",
    #   "catalog service v3",
    #   "Dashboard Visualization Service",
    #   "Workspace Context Adapter",
    #   "User Data API",
    #   "User Management Service",
    #   "Application Config Service"
    # ]
  }
}

variable "legacy_services" {
  default = {
    "<region_1>_<env>" = [
      "<Legacy_Services_API>"
    ]
    "<region_2>_<env>" = [
      "<Legacy_Services_API>"
    ]
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
        {
          name        = "workflow service v2"
          tag_ciid = {
            us = "CI000000005"
            au = "CI000000006"
            eu = "CI000000007"
            sg = "CI000000008" 
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
            us = "CI000000009"
            au = "CI000000010"
            eu = "CI000000011"
            sg = "CI000000012"
          }
        },        
      ]
    }   
    # Example configuration structure:
    # Replace team_alpha, team_beta with your actual team identifiers
    # Replace TEAM_NAME_ALPHA, TEAM_NAME_BETA with your actual team names
    # Replace service names with your actual service names
    # Replace CI IDs with your actual Configuration Item IDs for each region
  }    
}

variable "exclude_slo_monitors" {
  default = {
    "<region_1>_<env>" = [
      "<Frontend_Service>",
      "<Data_Visualization_Service>",
      "<Notification_Service>"
    ]
    "<region_2>_<env>" = [
      "<Frontend_Service>",
      "<Data_Visualization_Service>",
      "<Notification_Service>"
    ]
    # Example:
    # "us_prod" = [
    #   "Web_Frontend",
    #   "Dashboard_Analytics",
    #   "Email_Notification"
    # ]
  }
}

variable "legacy_service_scope" {
  default = {
    "<region_1>_<env>" = [
      "<Legacy_Services_API>"
    ]
    "<region_2>_<env>" = []
    # Example:
    # "us_prod" = [
    #   "Legacy_Platform_Services_api"
    # ]
  }
}

variable "exclude_cdf_metric_monitor" {
  default = {
    "<region_1>_<env>"  = [
      "<data_flow_activity_service>",
      "<data_extraction_service>"
    ]
    "<region_2>_<env>"  = [
      "<data_extraction_service>"
    ]
    # Example:
    # "us_prod" = [
    #   "etl-reporting-activity",
    #   "data-extract-service"
    # ]
  }
}


