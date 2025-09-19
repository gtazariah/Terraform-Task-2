provider "aws" {
    region = "ap-south-1"
    alias = "indian"
}

provider "aws"{
    region = "us-east-1"
    alias = "usa"
}

resource "aws_security_group" "sg-india" {
        provider = aws.indian
        name="nginx-sg-india"
        description = "allow http and ssh"

        ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]       
        }  

        ingress {
            from_port = 22
            to_port = 22
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }

        egress {
            from_port = 0
            to_port = 0
            protocol = "-1"
            cidr_blocks = ["0.0.0.0/0"]
        }
}

resource "aws_security_group" "sg-usa" {
  provider = aws.usa
  name="nginix-sg-usa"
  description = "allow http and ssh"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]    
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "india" {
    provider = aws.indian
    ami="ami-02d26659fd82cf299"
    instance_type = "t2.micro"
    security_groups = [aws_security_group.sg-india.name]
    user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install -y nginx
              sudo systemctl enable nginx
              sudo systemctl start nginx
              EOF       
  
}

resource "aws_instance" "america" {
    provider=aws.usa
    ami="ami-0360c520857e3138f"  
    instance_type = "t2.micro"
    security_groups = [aws_security_group.sg-usa.name]
    user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install -y nginx
              sudo systemctl enable nginx
              sudo systemctl start nginx
              EOF
}