source "amazon-ebs" "apache" {
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "cr-labs-packer"

  region = "us-east-2"
  /*  vpc_filter {
    filters = {
      "tag:Name" : "vpc1"
      "isDefault" : "false"
      "cidr" = "/16"
    }
  }
*/
  vpc_id        = "vpc-07e8409795527a55b"
  instance_type = "t2.micro"
  ami_name      = "packer-apache-ami-{{timestamp}}"

  subnet_filter {
    filters = {
      "tag:Name" : "pkr-tf-pub-subnet"
    }
  }

  source_ami_filter {
    filters = {
      virtualization-type = "hvm"
      name                = "ubuntu/images/*ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
    }
    owners      = ["099720109477"]
    most_recent = true
  }
  ssh_username = "ubuntu"
}

build {
  sources = ["source.amazon-ebs.apache"]

  provisioner "shell" {
    inline = [
      "sudo apt-add-repository --yes --update ppa:ansible/ansible",
      "sudo apt update -y",
      "sudo apt install ansible -y"
    ]
  }

  provisioner "ansible-local" {
    playbook_file = "../../ansible/apache.yml"
  }
}



