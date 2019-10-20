provider "aws" {
  access_key = "AKIA4EALQT3P36LMRS4L"
  secret_key = "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"
  region     = "us-east-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_security_group" "default" {
  name        = "terraform_example"
  description = "Used in the terraform"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from the VPC
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "test" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
    vpc_security_group_ids = ["${aws_security_group.default.id}"]
  key_name = "teraform"
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update",
      "sudo apt-get -y install nginx",
      "sudo service nginx start",
    ]
  }

  tags {
    Name = "new_test"
  }
}
output "public_instance_id" {
  value = "${aws_instance.test.id}"
}

output "public_instance_ip" {
  value = "${aws_instance.test.public_ip}"
}
output "address" {
  value = "${aws_instance.test.public_dns}"
}
