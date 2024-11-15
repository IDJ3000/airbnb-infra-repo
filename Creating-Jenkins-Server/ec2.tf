# Define the default AWS provider for us-east-1 region
provider "aws" {
  region = "us-east-1"
}

#Defining the instance resource
resource "aws_instance" "Jenkins-Server" {
  ami             = "ami-063d43db0594b521b" # Replace with your AMI for the instance
  instance_type   = "t2.large"
  key_name        = "Server-A-keypair"       # Replace with your key pair name
  vpc_security_group_ids = ["sg-018d7923729c07419"] # Replace with your security group ID

  tags = {
    Name = "Jenkins-Server"
  }



  user_data = <<-EOF
    #!/bin/bash
    # Ensure that your software packages are up to date on your instance by using the following command to perform a quick software update:
    sudo yum update –y
    sudo yum install wget -y

    # Add the Jenkins repo using the following command:
    sudo wget -O /etc/yum.repos.d/jenkins.repo \
        https://pkg.jenkins.io/redhat-stable/jenkins.repo

    #Import a key file from Jenkins-CI to enable installation from the package:
    sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

    sudo yum upgrade -y

    # Install Java (Amazon Linux 2023):
    sudo dnf install java-17-amazon-corretto -y

    sudo echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

    # Install Jenkins
    sudo yum install jenkins -y

    # Enable the Jenkins service to start at boot:
    sudo systemctl enable jenkins

    # Start Jenkins as a service:
    sudo systemctl start jenkins

    # Installing Git
    sudo yum install git -y
    EOF
}

# # Below is the Data Sources Block
# data "aws_ami" "app_ami" {
#   most_recent = true
#   owners      = ["amazon"]

#   filter {
#     name   = "name"
#     values = ["al2023-ami-*"] # This filters for Amazon Linux 2023 AMIs specifically
#   }
# }

# output "Jenkins-Server-Public-IP" {
#     value = aws_instance.Jenkins-Server.public_ip
# }

# output "Jenkins-Server-Private-IP" {
#     value = aws_instance.Jenkins-Server.private_ip
# }

# output "Jenkins-Server-DNS-Name" {
#     value = aws_instance.Jenkins-Server.public_dns
# }

# Creating security groups for Jenkins Server

# resource "aws_security_group" "Jenkins-Server-SG" {
#   name        = "Jenkins-Server-SG"
#   description = "Security group for Jenkins Server"
#   vpc_id      = aws_vpc.Jenkins-Server-VPC.id
#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["10.1.0.0/0"]
#   }
#   ingress {
#     from_port   = 8080
#     to_port     = 8080
#     protocol    = "tcp"
#     cidr_blocks = ["10.1.0.0/0"]
#   }
#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["10.1.0.0/0"]
#   }
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "Jenkins-Server-SG"
#   }
# }

