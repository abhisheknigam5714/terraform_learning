resource "aws_instance" "name" {
  ami           = "ami-035827357e3c7e810"
  instance_type = "t2.micro"
  key_name      = "practice"

}
