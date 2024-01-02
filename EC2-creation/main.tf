module "module1" {
  source = "./modules/module1"
}

resource "aws_instance" "app-server" {
  ami           = "ami-0c7217cdde317cfec"
  instance_type = var.instance-type
  key_name = "deployer-key"

   tags = {
    Name = var.instance_name
   }
}