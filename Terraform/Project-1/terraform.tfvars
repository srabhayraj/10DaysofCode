#subnet_prefix = "10.0.180.0/24"
# if we change the name or give name of terraform.tfvars file by our choice, eg. myvar.tfvars then we need to give this command
# terraform apply -var-file myvar.tfvars
# if we forget to assign a value for variable then it take the default value.

#subnet_prefix = ["10.0.1.0/24", "10.0.2.0/24"]

subnet_prefix = [{cidr_block = "10.0.1.0/24", name = "prod-subnet1"}, {cidr_block = "10.0.2.0/24", name = "dev-subnet1"}]