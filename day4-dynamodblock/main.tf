resource "aws_dynamodb_table" "terraform_lock" {
  name     = "terraform-lock"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

}
