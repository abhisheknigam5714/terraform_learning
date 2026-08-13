output "name" {
  description = "Name of the instance"
  value       = aws_instance.prod.tags["Name"]


}
output "instance_id" {
  description = "ID of the instance"
  value       = aws_instance.prod.id
  sensitive   = true
}
