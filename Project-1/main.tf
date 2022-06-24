provider "aws" {
  region = "ap-south-1"
  access_key = "AKIAT3Y63S4SFPS6WIP2"
  secret_key = "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"
}

# resource "aws_instance" "my_first_server" {
#   ami           = "ami-068257025f72f470d"
#   instance_type = "t2.micro"
#   tags = {
#     #Name = "ubuntu"
#   }
# }

# resource "aws_vpc" "first_vpc" {
#   cidr_block = "10.0.0.0/16"
#   tags = {
#     Name = "production"
#   }
# }

# resource "aws_subnet" "subnet-1" {
#   vpc_id     = aws_vpc.first_vpc.id
#   cidr_block = "10.0.1.0/24"

#   tags = {
#     Name = "prod-subnet"
#   }
# }

# resource "aws_vpc" "first_vpc" {
#   cidr_block = "10.0.0.0/16"
#   tags = {
#     Name = "production"
#   }
# }

# resource "aws_vpc" "second_vpc" {
#   cidr_block = "10.1.0.0/16"
#   tags = {
#     Name = "dev"
#   }
# }

# resource "aws_subnet" "subnet-2" {
#   vpc_id     = aws_vpc.second_vpc.id
#   cidr_block = "10.1.1.0/24"

#   tags = {
#     Name = "dev-subnet"
#   }
# }


#resource "<provider>_<resource_type>" "name" {
#      config options...connection {
 #     key = "value"
  #    key2 = "value"
   # }
  
#}#

# Sample Project
# 1. Create vpc
# 2. Create internet gateway
# 3. create custom route table
# 4. Create a subnet
# 5. Associate subnet with route table
# 6. Create security group to allow port 22,80,443
# 7. Create a network interface with an ip in the subnet that was carried in step 4
# 8. Assign an elastic ip to the network interface created in step 7
# 9. create ubuntu server snf install/enable apache2

variable "subnet_prefix" {
    description = "cidr block for the subnet"
    default = "10.0.57.0/24"
    #type = string
  
}


# Create Subnet
resource "aws_subnet" "subnet-1" {
    vpc_id = aws_vpc.prod-vpc.id
    cidr_block = var.subnet_prefix[0].cidr_block
    availability_zone = "ap-south-1a"

    tags = {
        Name = var.subnet_prefix[0].name
    }
}

resource "aws_subnet" "subnet-2" {
    vpc_id = aws_vpc.prod-vpc.id
    cidr_block = var.subnet_prefix[1].cidr_block
    availability_zone = "ap-south-1a"

    tags = {
        Name = var.subnet_prefix[1].name
    }
}



# Create VPC
resource "aws_vpc" "prod-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "production"
  }
}

# # Create internet gateway
# resource "aws_internet_gateway" "gw" {
#   vpc_id = aws_vpc.prod-vpc.id
# }

# # Create route table
# resource "aws_route_table" "prod-route-table" {
#   vpc_id = aws_vpc.prod-vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.gw.id
#   }

#   route {
#     ipv6_cidr_block        = "::/0"
#     gateway_id = aws_internet_gateway.gw.id
#   }

#   tags = {
#     Name = "Prod"
#   }
# }

# # Associate subnet with route table
# resource "aws_route_table_association" "a" {
#   subnet_id      = aws_subnet.subnet-1.id
#   route_table_id = aws_route_table.prod-route-table.id
# }

# # Create security group
# resource "aws_security_group" "allow_web" {
#   name        = "allow_web_traffic"
#   description = "Allow Web inbound traffic"
#   vpc_id      = aws_vpc.prod-vpc.id

#   ingress {
#     description      = "HTTPS"
#     from_port        = 443
#     to_port          = 443
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   ingress {
#     description      = "HTTP"
#     from_port        = 80
#     to_port          = 80
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   ingress {
#     description      = "SSH"
#     from_port        = 22
#     to_port          = 22
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   tags = {
#     Name = "allow_web"
#   }
# }

# # Create network interface
# resource "aws_network_interface" "web-server-nic" {
#   subnet_id       = aws_subnet.subnet-1.id
#   private_ips     = ["10.0.1.50"]
#   security_groups = [aws_security_group.allow_web.id]
# }

# # Create elastic (public) ip
# resource "aws_eip" "one" {
#   vpc                       = true
#   network_interface         = aws_network_interface.web-server-nic.id
#   associate_with_private_ip = "10.0.1.50"
#   depends_on = [aws_internet_gateway.gw]
# }

# output "server_public_ip" {
#     value = aws_eip.one.public_ip
# }

# output "server_private_ip" {
#     value = aws_instance.web-server-instance.private_ip
# }

# output "server_instance_id" {
#     value = aws_instance.web-server-instance.id  
# }

# output "server_instance_state" {
#     value = aws_instance.web-server-instance.instance_state  
# }

# # Create ubuntu server and install apache
# resource "aws_instance" "web-server-instance" {
#     ami = "ami-068257025f72f470d"
#     instance_type = "t2.micro"
#     availability_zone = "ap-south-1a"
#     key_name = "main-key"
    
#     network_interface {
#         device_index = 0
#         network_interface_id = aws_network_interface.web-server-nic.id
#     }

#     # user_data = <<-EOF
#     #             #! /bin/bash
#     #             sudo apt-get update
#     #             sudo apt-get install -y apache2
#     #             sudo systemctl start apache2
#     #             sudo systemctl enable apache2
#     #             echo "The page was created by Terraform" | sudo tee /var/www/html/index.html
#     # EOF

#     user_data = "${file("script.sh")}"

#     tags = {
#         Name = "web-server"
#     } 
# }


