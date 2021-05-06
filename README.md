# Learning-examples
Tutorials and hands-on labs. 

## Terraform-Packer-Ansible Lab
The goal of this lab is to build a compute VM image with Packer, provision it with Ansible, and deploy it with Terraform.

As a newbie this can be cumbersome. We will go through the process one step at a time, starting with Terraform.

### Terraform 
As we put our first steps into Terraform, it's best to use basic building blocks. 
At first, I used terraform to deploy a VM with default image from the marketplace. This helped me to learn the syntax of terraform files and practice the terraform cli commands.

Start by:
1. Deploy an Ubuntu VM using only `resource` blocks:
   
   Check the solution [here](./terraform/azure/ubuntu-vms/ubuntu-vm.tf). 
2. Deploy a Windows VM using a `module`:

    Check the solution [here](./terraform/azure/windows-vms/windows-vm.tf).

Any time you want to deploy, you need to configure your environment variables to authenticate with the cloud provider and then navigate to the appropriate directory to enter the following commands:
```shell
# Initialize the directory with terraform plugins
$ terraform init

# Check the execution plan to see what resources will be created
$ terraform plan

# Deploy the resources
$ terraform apply -auto-approve

# optionally you can check the state 
$ terraform state list
$ terraform state show <resource-name>

# Destroy/Delete the resources
$ terraform destroy -auto-approve
```

Next, we will deploy custom built images. To build the images we are using Packer. However, because we will use Ansible to install packages on our images, just check the absolutely simple ansible files [here](./ansible/).

### Packer
1. Use packer to build an Ubuntu 18.04 image provisioned with Python and Nginx, and publish it to your Azure account. 
    
    Check the packer file [here](./packer/azure/ubuntu.json.pkr.hcl)

    To build the image, navigate to the `packer/azure` directory and enter the command:
    ```shell
    $ packer build ubuntu.json.pkr.hcl
    ```

    Once the build finishes and the image is available. Deploy an instance of that image with Terraform. Check the terraform configuration [here](./terraform/azure/ubuntu-vms/custom-ubuntu-vm.tf).


2. Use packer to build a Windows Server 2019 provisioned with 7zip installed in `C:\Temp\` directory, and publish it to your Azure account.

    Check the packer file [here](./packer/azure/windows.json.pkr.hcl).

    To build the image, navigate to the `packer/azure` directory and enter the command:
    ```shell
    $ packer build windows.json.pkr.hcl
    ```

    Once the build finishes and the image is available. Deploy an instance of that image with Terraform. Check the terraform configuration [here](./terraform/azure/windows-vms/custom-windows-vm.tf).


3. Use packer to build an Ubuntu 18.04 image provisioned with Apache web server and publish it to your AWS account. 

    Check the packer file [here](./packer/aws/apache.pkr.hcl)

    To build the image, navigate to the `packer/aws` directory and enter the command:
    ```shell
    $ packer build apache.pkr.hcl
    ```

    Once the build finishes and the image is available. Deploy an instance of that image with Terraform. Check the terraform configuration [here](./terraform/aws/apache.tf).

Note that we are using **Ansible** to provision the images. The provisioner section in each packer file points to the playbook used to provision the image.
 

Other useful commands can include `packer fmt` and `packer validate`.

### Using CI/CD
After playing arround with Terraform, Packer, and Ansible, the time to automate everything has come. Using Jenkins, an image build and deploy can be instantiated automatically upon a git push. The repo contains a Jenkinsfile to automate the process of building an AWS AMI with Packer and launching an ec2 instance with Terraform.

To test it, make sure that your Jenkins is configured correctly and you have a webhook, then simply make an update and push it upstream.
