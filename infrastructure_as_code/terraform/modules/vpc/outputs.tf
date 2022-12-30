output "vpc_id" {
    value = aws_vpc.main_vpc.id
}

output "public_subnet_id_a" {
    value = aws_subnet.prod_subnet_public_a.id
}

output "public_subnet_id_b" {
    value = aws_subnet.prod_subnet_public_b.id
}

output "private_subnet_id_a" {
    value = aws_subnet.prod_subnet_private_a.id
}

output "private_subnet_id_b" {
    value = aws_subnet.prod_subnet_private_b.id
}

output "aws_web_security_group_id" {
    value = aws_security_group.allow_incoming_http_https.id
}

output "aws_mysql_security_group_id" {
    value = aws_security_group.allow_incoming_mysql.id
}

