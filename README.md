# AWS Elastic Beanstalk Flask Application

This repository contains Terraform code to deploy a sample Flask application on AWS Elastic Beanstalk.

## Prerequisites
- AWS account
- Terraform installed
- Flask project ZIP file

## Usage
1. Clone this repository.
2. Replace `/path/to/your/Flask-Blog-Project-main.zip` in `main.tf` with the path to your Flask project ZIP file.
3. Run `terraform init` to initialize the working directory.
4. Run `terraform apply` to apply the Terraform configuration and deploy the Flask application on AWS Elastic Beanstalk.

## Resources Created
- Elastic Beanstalk Application
- Elastic Beanstalk Environment
- API Gateway REST API
- API Gateway Resource
- IAM Role for Lambda Function
- RDS Instance
- API Gateway Method
- API Gateway Integration
- Security Group


