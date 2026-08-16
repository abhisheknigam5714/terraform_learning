module "dev" {
  source   = "../day2"
  ami      = "ami-035827357e3c7e810"
  type     = "t2.micro"
  key_name = "practice"
}
