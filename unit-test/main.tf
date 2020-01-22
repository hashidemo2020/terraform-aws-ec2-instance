terraform {
  required_version = ">= 0.12"
  
}

provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = var.tenancy
  tags = var.default_tags
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = var.default_tags
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/24"
  tags = var.default_tags
}

resource "aws_security_group" "lc_security_group" {
  name_prefix = var.project_name
  description = "Security group for the ${var.project_name} launch configuration"
  vpc_id      = aws_vpc.main.id

  # aws_launch_configuration.launch_configuration in this module sets create_before_destroy to true, which means
  # everything it depends on, including this resource, must set it as well, or you'll get cyclic dependency errors
  # when you try to do a terraform destroy.
  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    {
      "Name" = var.project_name
    },
    var.default_tags
  )
}

module "ec2-instance" {
  source  = "../"

  name                   = var.project_name
  instance_count         = 1

  ami                    = "ami-03fe4ab7cbc8fe59d"
  instance_type          = "t2.medium"
  key_name               = "Prakash Test"
  monitoring             = true
  #vpc_security_group_ids = [${aws_security_group.lc_security_group.id}]
  subnet_id              = aws_subnet.main.id

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}