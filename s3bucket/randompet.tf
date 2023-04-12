
#Changing the bucket name using random names
resource "random_pet" "pet_name" { #randompet has prefix can any name length can be any number
  prefix = "bootcamp30"
  length = 2

}