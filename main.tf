provider "aws" {
  region = "us-east-2"
}

variable "vpc_id" {
	default = "vpc-9e4777f7"
}

variable "source_cidr_block" {
	default = "10.0.0.0/21"
}

resource "aws_security_group" "web_sg" {
    name = "Web-Servers"
    description = "Security Group for web servers"
    vpc_id = "${var.vpc_id}"
    tags {
      Name = "web1"
    }
    // allows traffic from the SG itself
    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        self = true
    }

    // allow traffic for TCP 80
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["${var.source_cidr_block}"]
    }

    // allow traffic for TCP 443
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["${var.source_cidr_block}"]
    }
   // allow traffic for TCP 22 from own VPC
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${var.source_cidr_block}"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }  
}

output "web_sg_id" {
  value = "${aws_security_group.web_sg.id}"
}

resource "aws_instance" "ec2" {
  ami		= "ami-53f4312b"
  vpc_security_group_ids = ["${aws_security_group.web_sg.id}"]
  instance_type = "t2.micro"

}

