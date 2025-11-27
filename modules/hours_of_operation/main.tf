resource "aws_connect_hours_of_operation" "this" {
  instance_id = var.instance_id
  name        = "${var.name_prefix}-business-hours"
  description = "Business hours for Tele-Health of Bamenda"
  time_zone   = var.timezone

  dynamic "config" {
    for_each = var.business_hours
    content {
      day = config.key

      start_time {
        hours   = config.value.start_hour
        minutes = config.value.start_minute
      }

      end_time {
        hours   = config.value.end_hour
        minutes = config.value.end_minute
      }
    }
  }

  tags = {
    Project     = var.name_prefix
    Environment = var.name_prefix
    Type        = "HoursOfOperation"
  }
}
