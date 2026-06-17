# AWS CloudFront + S3 Static Website using Terraform

## Project Overview

This project demonstrates a secure static website deployment on AWS using Infrastructure as Code.

## Architecture

User
|
v
CloudFront CDN
|
v
Private S3 Bucket


## AWS Services Used

- Amazon S3
- Amazon CloudFront
- CloudFront Origin Access Control (OAC)
- IAM
- Terraform

## Features

- Private S3 bucket
- HTTPS delivery through CloudFront
- Secure S3 access using OAC
- Infrastructure deployment using Terraform
- Cloud automation

## Deployment

Initialize Terraform:

bash:
terraform init

Validate:
terraform validate

Deploy:
terraform apply

## Skills Demonstrated
AWS Architecture
Terraform Infrastructure as Code
Cloud Security
Serverless Architecture
Networking Concepts
