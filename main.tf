provider "aws" {
  region = "us-west-1"
}

resource "aws_instance" "ec2" {
  ami		= "ami-02eada62"
  instance_type = "t2.micro"

  tags {
  	Name = "terraform-example"
  }

}

