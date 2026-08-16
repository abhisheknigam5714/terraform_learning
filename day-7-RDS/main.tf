resource "aws_db_instance" "default" {
  allocated_storage = 10
  tags = {
    Name = "mydb"
  }
  engine         = "mysql"
  engine_version = "5.7"
  instance_class = "db.t3.micro"

  username             = "admin"
  password             = "admin1234"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.default.name
}


resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = ["subnet-0c5ad5f6cf5db11ab", "subnet-0438278fbe1e2a6c2"]

  tags = {
    Name = "My DB subnet group"
  }
}
