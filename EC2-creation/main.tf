resource "aws_instance" "test" {
  ami   = "ami-0ee4f2271a4df2d7d"
  instance_type = "t2.micro"
}