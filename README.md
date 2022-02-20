# miserere-webserver-s3-lambda

                                        ### miserere-webserver-s3-lambda-01 ###

A modular Terraform script that deploys an autoscaled UBUNTU 20.04 servers that sit under a classic load balancer, an S3 bucket,
and a Lambda function that is used to invoke to EC2 instances.
The script consists of three modules; a WebServer, S3, Lambda.

# WebServer Module:
Terraform script deployes a launch configuration for web servers, and autoscaling group configured with classic load balancer.
Additionally, two security groups are created, one that contrals what traffic go in and out of the ELB,
and another thats applied to each EC2 instance in the ASG.
Eventually an httpd service started via busybox.

# S3 Module:
S3 module deployes a private ACL bucket with versioning enabled.
Additionally, three files uploaded to the bucket:
    ssb.pem             --> this PEM will be used by the Lambda to ssh in to the Ec2 instances.
    packageParamiko.zip --> this is the python package needed to acctually ssh by Lambda.
    lambda-payload.zip  --> contains the python script that connects to EC2 and invokes a command, in our case it's an echo of some content in to "index.html" file.

# Lambda Module:
Deploys a lambda function with payload pulled from zipped file on S3 bucket,
a lambda layer with packageParamiko configured, IAM policy, and IAM role to be assumed by lambda when running.
