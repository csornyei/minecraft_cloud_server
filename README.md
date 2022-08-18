# Minecraft Cloud Server

I created this project to easily start minecraft servers on EC2 Spot instances.

It require `terraform` and `ansible`.

## How to use:

1. create AWS IAM user for Terraform and for S3 upload
2. add the credentials for the Terraform user to `~/.aws/credentials`
3. add variables to `terraform.tfvars`:
   - `sec_group_cidr_block`
   - `instance_type`
   - `route53_zone_name`
   - `url`
4. provision AWS resources with `terraform apply`
   - sometimes creating the ellastic ip fails as the instance is still pending, run `terraform apply` again in this case
5. add the S3 AWS user credentials and the AWS config to the ansible folder
6. inside the ansible folder run `ansible-playbook install_minecraft_server.yml -i hosts`
   - this will ask to add the remote to known hosts, say `yes`
7. Minecraft server should be running on `url`
