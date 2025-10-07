variable "synthetic_tests" {
  type  = list(object({
    locations = list(string)
    res_index = string
    name      = string
    app_url   = any
    status    = string
    message   = string    
    type      = string
    subtype   = string
    test_port = number
    test_data = object({
      follow_redirects   = bool
      accept_self_signed = bool
      test_method        = string
      tick_interval      = number
      priority           = number
      retry              = object({
        count             = number
        interval          = number
        renotify_interval = number
      })      
    })
    #assertions = any
    assertions = list(object({
        type     = string
        operator = string        
        target   = number
      }))
    tags        = list(string)
    create_test = bool
    
  }))
  description = "Synthetic test application configuration details"
}

