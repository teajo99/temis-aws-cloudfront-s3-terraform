# AWS CloudFront + S3 Static Website using Terraform

# ARCHITECTURE DIAGRAM
![image alt](https://github.com/teajo99/temis-aws-cloudfront-s3-terraform/blob/4f248f5a8960c9aea276236b864f6d4b5d4ad5ae/Architecture%20diagram.png)

Architecture diagram showing a secure AWS static website hosting solution. Users access a static website through Amazon CloudFront CDN over HTTPS. CloudFront retrieves content from a private Amazon S3 bucket using Origin Access Control (OAC), ensuring secure and restricted access. The infrastructure is deployed and managed using Terraform Infrastructure as Code, enabling automated provisioning of AWS resources including S3, CloudFront distribution, and IAM permissions.

## Project Overview

This project demonstrates a secure static website deployment on AWS using Infrastructure as Code.

## Architecture Decision

CloudFront was chosen to ensure secure, low-latency global delivery while keeping the S3 bucket private using Origin Access Control (OAC), following AWS security best practices.
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

```bash:
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

# temis-aws-cloudfront-s3-terraform
Secure AWS static website deployment using Terraform, S3, CloudFront, and Origin Access Control.

## Troubleshooting & Lessons Learned

During the deployment of this AWS CloudFront + S3 static website project, I encountered and resolved several issues.

---

## 1. CloudFront Showing AccessDenied Error

### Problem

After deploying the infrastructure with Terraform, accessing the CloudFront URL returned:
<Error> <Code>AccessDenied</Code> <Message>Access Denied</Message> </Error> ```
Cause

The S3 bucket and CloudFront distribution were created successfully, but the website files were not uploaded to the S3 bucket.

The Terraform state showed that the infrastructure resources existed, but the S3 objects were missing:
aws_s3_bucket.website
aws_cloudfront_distribution.website
aws_s3_bucket_policy.website

Missing:
aws_s3_object.index
aws_s3_object.styles
CloudFront was requesting index.html, but S3 did not contain the file.

Solution
Added Terraform resources to upload the website files:
index.html
styles.css

using:
aws_s3_object
After applying Terraform again, the files were uploaded to S3 and CloudFront successfully served the website.

2. Website Displayed Incorrect Emoji Characters
Problem

The website displayed:

ðŸš€

instead of:

🚀
Cause

The HTML document did not correctly handle UTF-8 character encoding.

Solution

Added UTF-8 metadata to the HTML file:

<meta charset="UTF-8">

The website was updated and redeployed.

3. Git Push Rejected by GitHub
Problem

When pushing the project to GitHub, Git returned:

! [rejected] main -> main (fetch first)
Cause

The GitHub repository already contained an initial commit, while the local repository had a different commit history.

The two repositories had unrelated histories.

Solution

Merged the remote repository history with the local project:

git pull origin main --allow-unrelated-histories
4. README Merge Conflict
Problem

After pulling from GitHub, Git reported:

CONFLICT (add/add): Merge conflict in README.md
Cause

Both the local project and GitHub repository contained their own versions of README.md.

Git could not automatically decide which version to keep.

Solution
Manually resolved the conflict by:
Removing Git conflict markers:
<<<<<<< HEAD
=======
>>>>>>> origin/main
Keeping the correct project documentation.
Adding and committing the resolved file:
git add README.md
git commit -m "Resolve README merge conflict"

## Key Lessons Learned
Always verify that application files are uploaded when using S3 as a CloudFront origin.
CloudFront can be configured correctly but still fail if the origin does not contain the required objects.
Private S3 origins require correct permissions between CloudFront and S3.
Git merge conflicts can occur when local and remote repositories have different histories.
Troubleshooting infrastructure requires checking both Terraform resources and AWS services.

