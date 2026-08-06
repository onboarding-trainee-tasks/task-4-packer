packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1.8"
    }
  }
}

source "amazon-ebs" "ansible" {
  region        = "eu-central-1"
  instance_type = "t3.micro"
  ssh_username  = "ubuntu"

  associate_public_ip_address               = true
  temporary_security_group_source_public_ip = true

  ami_name = "ansible-image-{{timestamp}}"

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
    Name    = "ansible"
    Project = "task-4"
    Role    = "ansible"
    BuiltBy = "packer"
  }
}

build {
  sources = [
    "source.amazon-ebs.ansible"
  ]

  provisioner "file" {
    source      = "ssh_private_key"
    destination = "/home/ubuntu/.ssh/ansible_ssh_private_key"
  }

  provisioner "shell" {
    script = "scripts/common.sh"
  }

  provisioner "shell" {
    script = "scripts/ansible_provision.sh"
  }

  post-processor "manifest" {
    output     = "packer-manifest.json"
    strip_path = true
  }
}