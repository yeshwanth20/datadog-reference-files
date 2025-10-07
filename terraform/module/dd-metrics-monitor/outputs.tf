
#output "datadog_synthetics_test_names" {
#  value       = datadog_synthetics_test.synthetic_test[*].name
#  description = "Names of the created Datadog Synthetic tests"
#}
#
#output "datadog_synthetic_tests" {
#  value       = datadog_synthetics_test.synthetic_test[*]
#  description = "The synthetic tests created in DataDog"
#}
#
#output "datadog_synthetic_test_tags" {
#  value       = datadog_synthetics_test.synthetic_test[*].tags[*]
#  description = "The synthetic tests created in DataDog"
#}

output "metrics_monitor_id" {
    value = {
        for k , v in datadog_monitor.metrics_monitor : k => v.id
    }
}