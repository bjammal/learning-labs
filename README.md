# learning-examples
Tutorials and labs I do when learning

## Ansible + Packer + Terraform Lab
The goal of this lab is to build a compute VM image with Packer, provision it with Ansible, and deploy it with Terraform.

To start, I first used terraform to deploy a VM with default image from the marketplace. This helped me to learn the syntax of terraform files and practice the terraform cli commands.

```shell
$ terraform init
$ terraform plan
$ terraform apply -auto-approve
$ terraform destroy -auto-approve
```
Next, I used packer+ansible to build and provision an image. 
```shell
$ packer build filename.hcl
```

Once the image is available, I used terraform again, with some slight changes wrt the files used in the first step, to deploy a VM of the packer-built image.

Those steps are performed for Linux and Windows OS.

## Using CI/CD
The branch `cicd` contains a Jenkinsfile to automate the process of building an AWS AMI with Packer and launching an ec2 instance with Terraform.

To test it, make sure that your Jenkins is configured correctly and you have a webhook, then simply make an update and push it upstream.
