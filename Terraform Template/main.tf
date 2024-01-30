provider "aws" {
  region = "us-east-1"
}

# Elastic Beanstalk Application
resource "aws_elastic_beanstalk_application" "RealestateAI_app" {
  name        = "RealestateAI-app"
  description = "Sample Flask Application"
} 

# Elastic Beanstalk Environment
resource "aws_elastic_beanstalk_environment" "RealestateAI_environment" {
  name        = "RealestateAIEnvironment"
  application = aws_elastic_beanstalk_application.RealestateAI_app.name

  solution_stack_name = "64bit Amazon Linux 2023 v4.0.8 running Python 3.11"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t3.micro"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = "1"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = "1"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "SingleInstance"
  }

  # Specify existing service role and instance profile
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = "aws-elasticbeanstalk-service-role"  
  }
  
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "EC2-Instance-Profile"  
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "RealestateAI_APP"
    value     = "/home/lokeshjoshi/EC2/Flask-Blog-Project-main.zip"  # Change this to the path of your Flask project ZIP file
  }
}

# API Gateway
resource "aws_api_gateway_rest_api" "RealestateAI_api" {
  name        = "RealestateAIAPI"
  description = "Sample API Gateway"
}

resource "aws_api_gateway_resource" "RealestateAI_api_resource" {
  rest_api_id = aws_api_gateway_rest_api.RealestateAI_api.id
  parent_id   = aws_api_gateway_rest_api.RealestateAI_api.root_resource_id
  path_part   = "resource"
}

# IAM Role for Lambda Function
resource "aws_iam_role" "RealestateAI_lambda_role" {
  name = "flaskLambdaRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# RDS Instance
resource "aws_db_instance" "RealestateAI_rds" {
  identifier           = "flaskrdsinstance"
  engine               = "mysql"
  instance_class       = "db.t2.micro"
  username             = "admin"
  password             = "password"
  allocated_storage    = 20
  storage_type         = "gp2"
  publicly_accessible  = false
  skip_final_snapshot    = false
  final_snapshot_identifier = "finalSnapshotIdentifier"
}

# API Gateway Method
resource "aws_api_gateway_method" "RealestateAI_api_method" {
  rest_api_id   = aws_api_gateway_rest_api.RealestateAI_api.id
  resource_id   = aws_api_gateway_resource.RealestateAI_api_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

# API Gateway Integration
resource "aws_api_gateway_integration" "RealestateAI_api_integration" {
  rest_api_id             = aws_api_gateway_rest_api.RealestateAI_api.id
  resource_id             = aws_api_gateway_resource.RealestateAI_api_resource.id
  http_method             = aws_api_gateway_method.RealestateAI_api_method.http_method
  integration_http_method = "POST"
  type                    = "MOCK"
}

# Security Group
resource "aws_security_group" "RealestateAI_sg" {
  name        = "RealestateAI-sg"
  description = "Security group for Flask application"
  vpc_id      = "vpc-0872d2409c3bc8182"  

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
