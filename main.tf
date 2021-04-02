terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  profile = "terraform"
  region  = "us-east-1"
}


resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "terafform-dashboard"

  dashboard_body = <<DEFINITION
{
    "widgets": [
        {
            "height": 6,
            "width": 6,
            "y": 0,
            "x": 6,
            "type": "metric",
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/ECS", "CPUUtilization", "ServiceName", "${var.service_name}", "ClusterName", "${var.cluster_name}", { "id": "m1" } ],
                    [ { "expression": "ANOMALY_DETECTION_BAND(m1, 2)", "label": "CPUUtilization (expected)", "id": "ad1", "color": "#95A5A6" } ],
                    [ "AWS/ECS", "MemoryUtilization", "ServiceName", "${var.service_name}", "ClusterName", "${var.cluster_name}", { "id": "m2" } ]
                ],
                "region": "us-east-1",
                "title": "${var.widget_prefix} CPU/Memory"
            }
        },
        {
            "height": 6,
            "width": 6,
            "y": 0,
            "x": 0,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", "${var.lb_id}", { "stat": "Minimum" } ],
                    [ "...", { "yAxis": "left", "stat": "Maximum" } ],
                    [ "..." ],
                    [ "...", { "stat": "p90" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "us-east-1",
                "title": "API Response Time",
                "period": 300,
                "stat": "p50"
            }
        },
        {
            "height": 6,
            "width": 6,
            "y": 0,
            "x": 12,
            "type": "metric",
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/ApplicationELB", "RequestCount", "LoadBalancer", "${var.lb_id}" ],
                    [ ".", "HTTPCode_Target_4XX_Count", ".", "." ],
                    [ ".", "HTTPCode_ELB_502_Count", ".", "." ],
                    [ ".", "HTTPCode_ELB_5XX_Count", ".", "." ]
                ],
                "region": "us-east-1",
                "title": "API Requests"
            }
        },
        {
            "height": 6,
            "width": 6,
            "y": 0,
            "x": 18,
            "type": "metric",
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/ApplicationELB", "ProcessedBytes", "LoadBalancer", "${var.lb_id}" ]
                ],
                "region": "us-east-1",
                "title": "Api Traffic"
            }
        }
    ]
}
DEFINITION
}
