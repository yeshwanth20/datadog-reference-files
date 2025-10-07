# 📊 DS Platform Datadog Terraform



[![Terraform](https://img.shields.io/badge/Terraform-1.10.0+-623CE4?logo=terraform&logoColor=white)](https://www.terraform.io/)

[![Datadog](https://img.shields.io/badge/Datadog-632CA6?logo=datadog&logoColor=white)](https://www.datadoghq.com/)



## 📋 Table of Contents



- [🎯 Overview](#-overview)

- [🏗️ Architecture](#️-architecture)

- [🚀 Quick Start](#-quick-start)

- [📁 Repository Structure](#-repository-structure)

- [🔧 Configuration](#-configuration)

- [🌍 Environments](#-environments)

- [👥 Team Management](#-team-management)

- [📊 Monitoring Types](#-monitoring-types)

- [🛠️ Development](#️-development)

- [🚀 Deployment](#-deployment)

- [📚 Documentation](#-documentation)

- [🤝 Contributing](#-contributing)



## 🎯 Overview



This repository contains **Terraform Infrastructure as Code (IaC)** for managing comprehensive Datadog monitoring resources. It provides automated deployment and management of:



- **📈 Metric Monitors** - CPU, Memory, Application performance

- **📝 Log Monitors** - Error detection, Service failures, Security events

- **🔍 Synthetic Tests** - API health checks, SSL certificate monitoring

- **📊 Service Level Objectives (SLOs)** - Critical API error rates, Latency targets

- **🚨 Alerting Rules** - Team-based notification routing



### ✨ Key Features



- 🌍 **Multi-Environment Support** - Development, Staging, Production

- 🌐 **Global Deployment** - US, EU, AU, SG regions

- 👥 **Team-Based Organization** - Dolphins, Orca, Sea Lions teams

- 🔄 **Automated CI/CD** - GitHub Actions integration

- 📊 **Comprehensive Monitoring** - Full observability stack

- 🛡️ **Enterprise Security** - Role-based access control



##


    subgraph "📊 Monitoring Stack"

        METRICS[📈 Metric Monitors]

        LOGS[📝 Log Monitors]

        SYNTHETIC[🔍 Synthetic Tests]

        SLO[📊 SLOs]

    end  
```



## 🚀 Quick Start



### Prerequisites



- **Terraform** >= 1.10.0

- **Git** for version control

- **Datadog API Key** and **Application Key**



### 1. Clone Repository



```bash



### 2. Environment Setup



```bash

# Set Datadog credentials

export DATADOG_API_KEY="your-api-key"

export DATADOG_APP_KEY="your-app-key"



# Initialize Terraform

cd terraform/env/deploy_all_non_multistep_api

terraform init

```



### 3. Plan and Apply



```bash

# Review changes

terraform plan



# Apply changes

terraform apply

```



## 📁 Repository Structure



```text

ds-platform-datadog-terraform/

├── 📁 terraform/

│   ├── 📁 env/

│   │   ├── 📁 deploy_all_non_multistep_api/     # Main monitoring infrastructure

│   │   │   ├── 📄 variables.tf                 # Main variable definitions

│   │   │   ├── 📄 variables_higher.tf          # Higher environment variables

│   │   │   ├── 📄 variables_higher_non_prod.tf # Non-prod higher env variables

│   │   │   ├── 📄 variables_lower.tf           # Lower environment variables

│   │   │   ├── 📄 terraform.tf                 # Terraform configuration

│   │   │   ├── 📄 heap_and_cpu_monitor.tf      # CPU and memory monitoring

│   │   │   ├── 📄 log_monitor.tf               # Log monitoring

│   │   │   ├── 📄 synthetic-test.tf            # Synthetic health checks

│   │   │   ├── 📄 synthetic-test-custom.tf     # Custom synthetic tests

│   │   │   ├── 📄 slo.tf                       # Service Level Objectives

│   │   │   ├── 📄 critical_errors.tf           # Critical error monitoring

│   │   │   ├── 📄 custom_monitor.tf            # Custom monitors

│   │   │   ├── 📄 cdf_nifi_monitor.tf          # CDF NiFi monitoring

│   │   │   ├── 📄 cdf_nifi_log_monitor.tf      # CDF NiFi log monitoring

│   │   │   └── 📄 kube_alert_team.tf           # Kubernetes alerts

│   │   └── 📁 deploy_multistep_api/             # Multi-step API monitoring

│   │       ├── 📄 main.tf                      # Multi-step configuration

│   │       ├── 📄 variables.tf                 # Multi-step variables

│   │       └── 📄 outputs.tf                   # Multi-step outputs

│   └── 📁 modules/                              # Reusable Terraform modules

├── 📁 .github/

│   └── 📁 workflows/

│       └── 📄 multistage-terraform-deploy.yaml # CI/CD pipeline

│       └── 📄 tlint-code-analysis.yaml         # Static code analysis

├── 📄 README.md                                # This file

├── 📄 LICENSE                                  # License information

└── 📄 .gitignore                               # Git ignore rules

```



### 🔍 Key Files Explained



| File | Purpose | Description |

|------|---------|-------------|

| `variables.tf` | Main Configuration | Primary team definitions and service configurations |

| `variables_higher.tf` | Higher Environments | Stage and production environment configurations |

| `variables_lower.tf` | Lower Environments | Development and QA environment configurations |

| `terraform.tf` | Terraform Setup | Provider configuration and backend settings |

| `heap_and_cpu_monitor.tf` | Resource Monitoring | CPU and memory usage alerts for services |

| `log_monitor.tf` | Log Monitoring | Error detection and service failure alerts |

| `synthetic-test.tf` | Health Checks | API endpoint and SSL certificate monitoring |

| `synthetic-test-custom.tf` | Custom Tests | Specialized synthetic monitoring tests |

| `slo.tf` | SLO Management | Service Level Objectives for critical APIs |

| `critical_errors.tf` | Error Monitoring | Critical error rate and threshold monitoring |

| `cdf_nifi_monitor.tf` | NiFi Monitoring | CDF NiFi dataflow monitoring |

| `kube_alert_team.tf` | Kubernetes Alerts | Container and pod-level monitoring |



## 🔧 Configuration



### Team Structure



The monitoring configuration is organized around teams, with each team managing specific services:



```hcl

teams = {

  team_1 = {

    team_name = "TEAM_NAME_1"  # Maps to "Orca" team

    services = [

      {

        name                = "Power BI"

        notify_non_prod     = "@teams-Orca_Non_Prod_Alerts_Channel"

        notify_prod         = "@teams-Orca_Prod_Alerts_Channel"

        tag_ciid = {

          us = "CI58685180"

          au = "CI58685184"

          eu = "CI58685186"

          sg = "CI58685188"

        }

        # ... additional monitor configurations

      }

    ]

  }

}

```



### Variable Structure



```text

Team Configuration

├── team_name (TEAM_NAME_1, TEAM_NAME_2, etc.)

└── services[]

    ├── name (Service display name)

    ├── notify_non_prod (Non-production notifications)

    ├── notify_prod (Production notifications)

    ├── tag_ciid (CI/CD identifiers by region)

    │   ├── us, eu, au, sg

    ├── synthetic_test[] (Health checks and SSL monitoring)

    ├── synthetic_oauth_login_test[] (OAuth workflow tests)

    └── critical_alerts[] (Error rate monitoring)

```



## 🌍 Environments



| Environment | Code | Regions | Purpose |

|-------------|------|---------|---------|

| **US Staging** | `usstg` | US | US pre-production validation |

| **EU Staging** | `eustg` | EU | EU pre-production validation |

| **US Production** | `usprod` | US | US live production services |

| **EU Production** | `euprod` | EU | EU live production services |

| **AU Production** | `auprod` | AU | Australia live production services |

| **SG Production** | `sgprod` | SG | Singapore live production services |



#


## 📊 Monitoring Types



### 📈 Metric Monitors



- **CPU Usage**: Critical and high thresholds

- **Memory Usage**: Application performance monitoring

- **Custom Metrics**: Business-specific KPIs



### 📝 Log Monitors



- **Error Detection**: Application errors and exceptions

- **Service Failures**: Startup and runtime failures

- **Security Events**: Authentication and authorization issues



### 🔍 Synthetic Tests



- **API Health Checks**: Endpoint availability and response time

- **SSL Certificate Monitoring**: Certificate expiration alerts

- **Multi-step Workflows**: Complex user journey validation



### 📊 Service Level Objectives (SLOs)



- **Error Rate SLOs**: Critical API error thresholds

- **Latency SLOs**: Response time targets

- **Availability SLOs**: Service uptime requirements



## 🛠️ Development



### Adding New Monitors



1. **Edit Team Configuration**:



   ```bash

   # Navigate to the appropriate environment

   cd terraform/env/deploy_all_non_multistep_api



   # Edit variables.tf

   vim variables.tf

   ```



2. **Add New Team**:



   ```hcl

   # Copy existing team block and modify

   team_new = {

     team_name = "TEAM_NAME_NEW"

     services = [

       {

         name                = "New Service"

         notify_non_prod     = "@teams-New_Team_Non_Prod_Channel"

         notify_prod         = "@teams-New_Team_Prod_Channel"

         tag_ciid = {

           us = "CI12345678"

           au = "CI12345679"

           eu = "CI12345680"

           sg = "CI12345681"

         }

         # Add monitor configurations

       }

     ]

   }

   ```



3. **Add New Service**:



   ```hcl

   # Add to existing team's services array

   {

     name                = "Additional Service"

     notify_non_prod     = "@teams-Existing_Team_Non_Prod_Channel"

     notify_prod         = "@teams-Existing_Team_Prod_Channel"

     synthetic_test = [

       {

         url_suffix = "-pwclabs.pwcglb.com/api/v1/actuator/health"

         type       = "health"

       }

     ]

     # Configure additional monitors and tests

   }

   ```



### Local Development



```bash

# Format Terraform code

terraform fmt -recursive



# Validate configuration

terraform validate



# Plan changes

terraform plan



```



## 🚀 Deployment



### CI/CD Pipeline



The repository uses **GitHub Actions** for automated deployment:



- **Trigger**: Push to `main` branch or manual dispatch

- **Environments**: Automatic deployment to all environments

- **Validation**: Terraform plan validation before apply



### Deployment Order



1. **🟢 Lower Environment** - Development and QA validation

2. **🟡 Stage Environment** - Pre-production testing

3. **🔴 Production Environment** - Live service deployment



## 📚 Documentation



### Key Resources



- **[Terraform Documentation](https://www.terraform.io/docs)** - Official Terraform guides

- **[Datadog Provider](https://registry.terraform.io/providers/DataDog/datadog/latest/docs)** - Terraform Datadog provider

- **[Datadog API](https://docs.datadoghq.com/api/)** - Datadog API documentation

- **[GitHub Actions](https://docs.github.com/en/actions)** - CI/CD pipeline documentation



## 🤝 Contributing



### Development Workflow



1. **Create Feature Branch**:



   ```bash

   git checkout -b feature/add-new-monitor

   ```



2. **Make Changes**:

   - Update `variables.tf` with new configurations

   - Add or modify monitor definitions

   - Update documentation as needed



3. **Test Changes**:



   ```bash

   terraform fmt -recursive

   terraform validate

   terraform plan

   ```



4. **Submit Pull Request**:

   - Provide detailed description of changes

   - Include terraform plan output

   - Request review from team members



### Code Standards



- **Formatting**: Use `terraform fmt` for consistent formatting

- **Naming**: Follow kebab-case for resource names

- **Documentation**: Update README.md for significant changes

- **Testing**: Validate all changes with `terraform plan`



### Getting Help



- **Issues**: Create GitHub issue for bugs or feature requests

- **Questions**: Reach out to relevant team channels



### Workflow Links
