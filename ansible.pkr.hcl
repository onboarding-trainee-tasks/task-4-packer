packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1.8"
    }
  }
}

variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

variable "image_version" {
  type = string
}


source "amazon-ebs" "ansible" {
  region        = var.aws_region
  instance_type = "t3.micro"
  ssh_username  = "ubuntu"

  associate_public_ip_address = true
  temporary_security_group_source_public_ip = true

  ami_name = "ansible-image-${var.image_version}-{{timestamp}}"

  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
      architecture        = "x86_64"
    }

    owners      = ["099720109477"]
    most_recent = true
  }

  launch_block_device_mappings {
    device_name           = "/dev/sda1"
    volume_type           = "gp3"
    volume_size           = 10
    delete_on_termination = true
    encrypted             = true
  }

  tags = {
    Name        = "ansible-${var.image_version}"
    Project     = "task-4"
    Role        = "ansible"
    Version     = var.image_version
    BuiltBy     = "packer"
  }
}

build {
  sources = [
    "source.amazon-ebs.ansible"
  ]

  provisioner "file" {
    source      = "C:/Onboarding/.ssh/terraform-ssh-key.pem"
    destination = "/home/ubuntu/.ssh/terraform-ssh-key.pem"
  }

  provisioner "shell" {
    script = "scripts/common.sh"
  }

  provisioner "shell" {
    script = "scripts/ansible_provision.sh"
  }
}