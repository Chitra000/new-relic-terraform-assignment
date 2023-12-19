# resource "newrelic_alert_policy" "policy-1" {
#   count = 2
#   name = "policy-1.${count.index + 1}"
  
# }
# resource "newrelic_alert_policy" "policy-2" {
#   for_each = toset(var.p_name)
#   name = "policy-2.${each.value}"
  
# }
resource "newrelic_alert_policy" "my_policy" {
  name = "my_policy"
}

resource "newrelic_nrql_alert_condition" "condition-1" {
  for_each = var.alert_loop
  account_id                     = 4268441
  policy_id                      = newrelic_alert_policy.my_policy.id
  type                           = each.value.type
  name                           = each.value.name
  description                    = each.value.description
  runbook_url                    = each.value.runbook_url
  enabled                        = each.value.enabled
  violation_time_limit_seconds   = each.value.violation_time_limit_seconds
  fill_option                    = each.value.fill_option
  fill_value                     = each.value.fill_value
  aggregation_window             = each.value.aggregation_window
  aggregation_method             = each.value.aggregation_method
  aggregation_delay              = each.value.aggregation_delay
  expiration_duration            = each.value.expiration_duration
  open_violation_on_expiration   = each.value.open_violation_on_expiration
  close_violations_on_expiration = each.value.close_violations_on_expiration
  slide_by                       = each.value.slide_by


  nrql {
    query = each.value.nrql
  }

  critical {
    operator              = each.value.critical.operator
    threshold             = each.value.critical.threshold
    threshold_duration    = each.value.critical.threshold_duration
    threshold_occurrences = each.value.critical.threshold_occurrences
  }

  warning {
    operator              = each.value.warning.operator
    threshold             = each.value.warning.threshold
    threshold_duration    = each.value.warning.threshold_duration
    threshold_occurrences = each.value.warning.threshold_occurrences
  }
}


resource "newrelic_one_dashboard" "my-dash" {
  name        = "New Relic Dashboard Example"
  permissions = "public_read_only"

  page {
    name = "New Relic Dashboard Example"

    widget_billboard {
      title  = "Requests per minute"
      row    = 1
      column = 1
      width  = 4
      height = 3

      nrql_query {
        query = "FROM Transaction SELECT rate(count(*), 1 minute)"
      }
    }

    widget_line {
      title = "Overall CPU % Statistics"
      row = 1
      column = 5
      height = 3
      width = 4

      nrql_query {
        query = <<EOT
SELECT average(cpuSystemPercent), average(cpuUserPercent), average(cpuIdlePercent), average(cpuIOWaitPercent) FROM SystemSample  SINCE 1 hour ago TIMESERIES
EOT
      }
      facet_show_other_series = false
      legend_enabled = true
      ignore_time_range = false
      y_axis_left_zero = true
      y_axis_left_min = 0
      y_axis_left_max = 0
      null_values {
        null_value = "default"

        series_overrides {
          null_value = "remove"
          series_name = "Avg Cpu User Percent"
        }

        series_overrides {
          null_value = "zero"
          series_name = "Avg Cpu Idle Percent"
        }

        series_overrides {
          null_value = "default"
          series_name = "Avg Cpu IO Wait Percent"
        }

        series_overrides {
          null_value = "preserve"
          series_name = "Avg Cpu System Percent"
        }
      }

    }

  }
}


