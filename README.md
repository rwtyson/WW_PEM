# WW_PEM
WW Platform Engineering Manager Take Home Assessment
WW Platform Engineering Manager (SRE) Take Home Assessment
AWS knowledge Problem Statement: Deploy a highly available scalable and resilient AWS infrastructure based off of EC2 AMI’s that will be exposed to the public internet on port 443 with SSL enabled. Expected Result: ● A playbook of your choice using your choice of tool (aws cli, terraform, cloudformation, etc...) that includes the steps needed to create the infrastructure.

○ We do not need to see results of the commands actually creating the infrastructure in your environment

○ Accuracy of the script will be reviewed and evaluated ○ Best practices around general security for the design will be evaluated ● You will be expected to articulate different decisions that could have been made and why you chose to go with what you did

○ If you want to add comments to the script to pre-populate the discussion, that would be great

Output:

Create a git repo or gist with the output and share it with your Recruiter so we can access and assess it Please use the following data to inform your decisions and the data in your commands: AWS values to use in your submission to avoid sensitive data:

● AWS_ACCESS_KEY=abcdefgh

● AWS_SECRET_KEY=rew24w3wer4

● AWS_VPC_ID=vpc-0000000000000

● AWS_SUBNET_A=subnet-111111111111

● AWS_SUBNET_B=subnet-22222222222

● AWS_SUBNET_C=subnet-33333333333

● AWS_SUBNET_D=subnet-44444444444

● AWS_PUBLIC_SUBNET_A=subnet-55555555555

● AWS_PUBLIC_SUBNET_B=subnet-66666666666

● AWS_PUBLIC_SUBNET_C=subnet-77777777777

● AWS_PUBLIC_SUBNET_D=subnet-88888888888

● AWS_ACM_CERT_ARN=arn:aws:acm:us-east-1:99999999999:certificate/4dd9207 2-a3ed-40b1-9f09-0b968d7c6043

● AWS_AMI_ID=ami-11111111111111

System Requirements:

● EC2 based deployments off of an AMI already provided

○ The AMI will have a web server listening on 0.0.0.0:8192 with arch=amd64

○ The AMI requires 500GB of storage with > 250MB/s of throughput

○ The AMI requires a minimum of 3 CPU’s worth of work

○ The AMI requires a minimum of 12GB of Memory

○ AMI Security

■ Exposed port 8192 to the load balancer

■ Exposed port 22 on 10.0.0.0/16

○ We should be able to scale easily between 2 and 10 nodes, with a default of 5

● The Load balancer should automatically distribute load to EC2 machines as they are scaled up or down

○ Serving port 443 to anyone on the internet

This should take less than 60 minutes, so feel free to assume that all API calls succeed.
