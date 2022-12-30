output "db_instance_address" {
  description = "The address of the RDS instance"
  value       = aws_db_instance.prod_timeoff_db.address
}