resource "aws_db_subnet_group" "prod_timeoff_subnet_group" {
  name       = "prod_timeoff_subnet_group"
  subnet_ids = [var.private_subnet_id_a, var.private_subnet_id_b]
}

resource "aws_db_instance" "prod_timeoff_db" {
  identifier           = "prod-timeoff-rds"
  allocated_storage    = 10
  db_name              = var.mysql_database_name
  engine               = "mysql"
  engine_version       = "8.0.28"
  instance_class       = "db.t2.micro"
  username             = var.mysql_database_username
  password             = var.mysql_database_password
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.prod_timeoff_subnet_group.name
  vpc_security_group_ids = [var.aws_mysql_security_group_id]
}
