provider "aws" {
  region = var.region
}

/*resource "random_integer" "num" {
  max = 100
  min = 2
  
}*/
#Lets use conditions to determine weather a bucket should be created or not
