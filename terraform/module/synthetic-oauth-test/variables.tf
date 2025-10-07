variable "include_tags" {
  type        = bool
  default     = true
  description = "whether notifications from this monitor automatically insert its triggering tags into the title"
}

variable "synthetic_tests" {
 type = any
}

# variable "synthetic_tests" {
#   type  = list(object({
#     locations = list(string)
#     res_index = string
#     name      = string
#     app_url   = string
#     status    = string
#     message   = string
#     auth_username = string
#     auth_password = string
#     test_data = object({
#       follow_redirects   = bool
#       accept_self_signed = bool
#       test_type          = string
#       test_subtype       = string
#       test_method        = string
#       tick_interval      = number
#       test_port          = number
#       retry              = object({
#         count             = number
#         interval          = number
#         renotify_interval = number
#       })
#       assertions = list(object({
#         type     = string
#         operator = string
#         target   = any
#       //  targetjsonpath = any
#       }))
#     })
#     tags        = list(string)
#     create_test = bool
#   }))
#   description = "Synthetic test application configuration details"
# }

# variable "type" {
#   description = "Valid values are body, header, statusCode, certificate, responseTime, property, recordEvery, recordSome, tlsVersion, minTlsVersion, latency, packetLossPercentage, packetsReceived, networkHop."
#   default     = "body"
# }
# variable "operator" {
#   default     = "contains"
#   description = "like= 'contains', 'doesNotContain', 'is', 'isNot', 'matches', 'doesNotMatch', 'validates'"
# }
# variable "target" {
#   description = ""
#   default     = "wexp-bearer"
# }
# variable "target_1" {
#   description = ""
#   default     = "x-csrf-token"
# }

# variable "connection" {
#   description = ""
#   default     = "keep-alive"
# }

# variable "encoding" {
#   description = ""
#   default     = "gzip, deflate, br"
# }


