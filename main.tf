module "s3" {
  source = "./s3bucket"
  #region = "us-east-2"  This is another way of giving values to your variables in the modules
  #create_vpc = true Alternative ways of doing this is shown below: variablizing a variable.
  region = var.aws_region
  create_vpc = var.create_vpc_network
}

variable "aws_region" {
  type = string
  #default = "us-east-2"
}

variable "create_vpc_network" {
  type = bool
  #default = true
}