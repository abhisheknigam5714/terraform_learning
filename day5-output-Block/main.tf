resource "aws_instance" "prod" {
  ami           = "ami-035827357e3c7e810"
  instance_type = "t2.micro"
  key_name      = "practice"
  tags = {
    Name = "dev"
  }

}
