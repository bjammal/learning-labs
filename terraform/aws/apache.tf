data "aws_ami" "my_ami" {
  most_recent      = true
  name_regex       = "^packer-apache-ami-\\d{3}"
  owners           = ["self"]

  filter {
    name   = "name"
    values = ["packer-apache-ami-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

module "ec2_instance" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "~> 2.0"

  name                   = "pkr-tf-apache-instance"
  instance_count         = 1

  ami                    = data.aws_ami.my_ami.id
  instance_type          = "t2.micro"
  key_name               = "cr-labs"
  vpc_security_group_ids = ["sg-06fc7000fcbf74e08"]
  subnet_id              = "subnet-0b9da3dc9fbd943d3"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}