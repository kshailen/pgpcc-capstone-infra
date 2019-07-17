# pgpcc-capstone-infra
This repo has teraafrom code for PGPCC capstone project

### Prerequisite 
1. You should have terraform version v0.12.3 installed.
2. aws profile should be setup as `lab-user`
  ```$xslt
   see following type of entries in you ~/.aws/credentials file
   [lab-user]
   aws_access_key_id = xxxxxxxxxxxxxxxxxxxxxxxxxxxxx
   aws_secret_access_key = xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

```
If entries are not there then run following command to configure `lab-user` profile
```bash
$ aws configure --profile user2
AWS Access Key ID [None]: xxxxxxxxxxxxxxxxxxxxxxxxxxxxx
AWS Secret Access Key [None]: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
Default region name [None]: us-east-1
Default output format [None]: json

```

## How to use this code.
This code is using lab-profile user of my account that`s why it is required to use lab-user profile

```$xslt
git clone https://github.com/kshailen/pgpcc-capstone-infra.git 
cd pgpcc-capstone-infra/
terraform init
terraform plan
terraform apply
```

I have pushed `.tfstate` files also and infra is already up and running so you don't have to do terraform apply.


### How to she what is created

Run following command.
```bash
$ terraform show
```

### How to see what is IP of bastion host , what is LB DNS ?
```bash
$ terraform output bastion_ip_us
3.220.91.193
$ terraform output LB_DNS_NAME
pgpcc-capston-570937511.us-east-1.elb.amazonaws.com
$ terraform output Apache_server_ip
10.0.0.157
$ 

```

### How to see all ouputs
```bash
$ terraform output
Apache_server_ip = 10.0.0.157
LB_DNS_NAME = pgpcc-capston-570937511.us-east-1.elb.amazonaws.com
bastion_ip_us = 3.220.91.193
private_subnets = [
  "subnet-04a7c194d9f04b790",
  "subnet-0ca88766a77bb9963",
  "subnet-053ba2cb6a50dff25",
]
public_subnets = [
  "subnet-01811508bd9ccb7db",
  "subnet-0e07ff0e956229cda",
]

```