variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-2"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "aws-devops-app"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}
variable "alert_email" {
  description = "Email address for CloudWatch alerts"
  type        = string
}