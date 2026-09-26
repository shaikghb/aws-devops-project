# AWS DevOps Project

A containerized Flask application deployed on AWS using Terraform, Amazon ECS Fargate, Amazon ECR, Application Load Balancer, GitHub Actions CI/CD, CloudWatch monitoring, auto-scaling, and deployment rollback.

## Project Overview

This project demonstrates an end-to-end DevOps workflow for deploying a Python Flask application to AWS.

The application provides two endpoints:

- `/` - Application home endpoint
- `/health` - Health check endpoint

Terraform is used to create and manage the AWS infrastructure, while GitHub Actions automates testing, Docker image creation, security scanning, and deployment to Amazon ECS.

---

## Architecture

```text
Developer
    |
    v
GitHub Repository
    |
    v
GitHub Actions
    |
    +----> Run Python Tests
    |
    +----> Build Docker Image
    |
    +----> Trivy Security Scan
    |
    +----> Push Image to Amazon ECR
    |
    v
Amazon ECS Fargate
    |
    v
Application Load Balancer
    |
    v
Flask Application

Monitoring and Scaling

ECS / ALB / Application Logs
            |
            v
      Amazon CloudWatch
            |
       +----+----+
       |         |
       v         v
   Dashboard   Alarms
                 |
                 v
                SNS

Technologies Used
Application
Python
Flask
Pytest
Gunicorn
Containerization
Docker
AWS
Amazon VPC
Amazon ECS Fargate
Amazon ECR
Application Load Balancer
Amazon CloudWatch
Amazon SNS
IAM
AWS Auto Scaling
DevOps
GitHub
GitHub Actions
GitHub OIDC
Terraform
Trivy
Project Structure
aws-devops-project/
│
├── app/
│   ├── app.py
│   └── requirements.txt
│
├── tests/
│   └── test_app.py
│
├── terraform/
│   ├── autoscaling.tf
│   ├── dashboard.tf
│   ├── error-monitoring.tf
│   ├── logging.tf
│   ├── alb.tf
│   ├── ecs.tf
│   ├── service.tf
│   ├── task-defination.tf
│   └── ...
│
├── .github/
│   └── workflows/
│
├── Dockerfile
├── .dockerignore
├── .gitignore
└── README.md

Application Endpoints
Home
/

Response:

AWS DevOps Project is running!
Health Check
/health

Response:

OK

The /health endpoint is used by the Application Load Balancer to determine whether the ECS task is healthy.

Local Setup
1. Clone the Repository
git clone https://github.com/shaikghb/aws-devops-project.git
cd aws-devops-project
2. Install Dependencies
py -m pip install -r app/requirements.txt
3. Run Tests
py -m pytest -v

Expected result:

2 passed
4. Run the Application
py app/app.py

The application runs on:

http://localhost:5000

Health check:

http://localhost:5000/health
Docker
Build the Docker Image
docker build -t aws-devops-app .
Run the Container
docker run -p 5000:5000 aws-devops-app

Open:

http://localhost:5000
Infrastructure with Terraform

Terraform is used to create and manage the AWS infrastructure.

Main infrastructure components include:

VPC
Public subnets
Internet Gateway
Route tables
Security groups
ECS cluster
ECS Fargate service
ECS task definition
Application Load Balancer
Target group
CloudWatch log group
CloudWatch alarms
CloudWatch dashboard
SNS topic
ECS auto-scaling
Initialize Terraform
cd terraform
terraform init
Validate Configuration
terraform validate
Review Changes
terraform plan
Apply Infrastructure
terraform apply
CI/CD Pipeline

GitHub Actions automates the application deployment process.

The pipeline performs the following steps:

Code Push
    |
    v
Run Tests
    |
    v
Configure AWS using GitHub OIDC
    |
    v
Login to Amazon ECR
    |
    v
Build Docker Image
    |
    v
Trivy Security Scan
    |
    v
Push Image to ECR
    |
    v
Update ECS Task Definition
    |
    v
Deploy to ECS
    |
    v
Application Load Balancer

This allows changes pushed to the repository to go through an automated deployment workflow.

GitHub OIDC

GitHub Actions uses OpenID Connect (OIDC) to authenticate with AWS.

This avoids storing long-term AWS access keys in the GitHub Actions workflow.

The workflow obtains temporary AWS credentials through the configured IAM role.

Amazon ECR

The Docker image is stored in Amazon Elastic Container Registry.

ECR repository:

aws-devops-app

Images are tagged using the Git commit SHA so that deployments can be associated with a specific version of the source code.

Amazon ECS Fargate

The application runs as a container on Amazon ECS using AWS Fargate.

The ECS service is configured with:

Desired count: 1
CPU: 256
Memory: 512 MiB
Container port: 5000
Health check path: /health
Application Load Balancer

The Application Load Balancer receives HTTP traffic and forwards requests to the ECS service.

The target group uses:

Port: 5000
Protocol: HTTP
Health Check: /health

The ECS security group allows application traffic from the Application Load Balancer security group.

Auto Scaling

ECS service auto-scaling is configured using the average CPU utilization of the ECS service.

Configuration:

Minimum tasks: 1
Maximum tasks: 3
Target CPU utilization: 70%
Scale-out cooldown: 60 seconds
Scale-in cooldown: 300 seconds

This allows the service to increase or decrease the number of running tasks based on CPU utilization.

Monitoring

Amazon CloudWatch is used for monitoring the application and infrastructure.

The CloudWatch dashboard contains metrics for:

ECS CPU utilization
ECS memory utilization
ECS running task count
ALB request count
ALB target response time
ALB unhealthy hosts
Application Error Monitoring

Application logs are stored in:

/ecs/aws-devops-app-dev

A CloudWatch metric filter searches application logs for:

ERROR

When an ERROR message is detected, CloudWatch records an application error metric.

The CloudWatch alarm is configured with:

Threshold: 1
Period: 60 seconds
Statistic: Sum

The alarm sends notifications through the configured SNS topic.

Error Monitoring Test

The application error monitoring system was tested using a controlled log message:

ERROR - controlled monitoring test

The test successfully caused the CloudWatch alarm to enter:

ALARM

After removing the test log stream and allowing the metric period to expire, the alarm returned to:

OK

This verified the application error monitoring flow.

Deployment Rollback

The ECS deployment circuit breaker is enabled with rollback.

Configuration:

Deployment circuit breaker: Enabled
Rollback: Enabled

A controlled deployment test was performed using an intentionally non-working application command.

The unhealthy deployment failed its ALB health checks, and ECS automatically rolled back to the previous healthy task definition.

This verified the deployment rollback mechanism.

Security

Security-related features implemented in the project include:

GitHub OIDC authentication
No long-term AWS access keys required by the CI/CD workflow
Trivy container security scanning
Non-root Docker container user
ECS security group restricted to ALB traffic
Testing

The project contains automated tests using Pytest.

Current tests verify:

Home endpoint returns HTTP 200
Health endpoint returns HTTP 200
Expected response messages are returned

Run:

py -m pytest -v

Expected result:

2 passed
Deployment Verification

The deployed application can be verified using the Application Load Balancer endpoint.

Health endpoint:

http://<ALB-DNS>/health

Expected response:

OK
Key DevOps Concepts Demonstrated

This project demonstrates practical implementation of:

Infrastructure as Code
Containerization
CI/CD
Cloud deployment
GitHub Actions
AWS OIDC
Container registry
ECS Fargate
Load balancing
Health checks
Auto-scaling
Monitoring
Logging
Alerting
Security scanning
Deployment rollback
Infrastructure monitoring
Author

Shaik Abzal Sharif

DevOps Engineer