#Create SNS topic to send function results to
resource "aws_sns_topic" "results_updates" {
    name = "${var.project_name}-sns-topic"
}