output "ec2_public_dns" {
  description = "Web Host Public DNS Name"
  value = aws_ec2_instance_state.ec2_instance.state
}

output "vpc_id" {
  description = "The ID of the VPC"
  value = aws_vpc.web_vpc.arn
}

output "public_subnet" {
  description = "The ID of the Public Subnet"
  value = aws_subnet.web_subnet.id
}

output "public_subnet2" {
  description = "The ID of the Public Subnet"
  value = aws_subnet.web_subnet2.id
}

output "user_name" {
  description = "The Name of the IAM User"
  value = aws_iam_user.user.arn
}

output "secret_key" {
  description = "The Secret Key of the IAM User"
  value = aws_iam_access_key.access_key.secret
}

output "db_app_public_dns" {
  description = "DB App Public DNS Name"
  value = aws_ec2_instance_state.db_app_instance.state
}

output "db_endpoint" {
  description = "DB Endpoint"
  value = "${aws_db_instance.default_db.address}:{DefaultDB.Endpoint.Port}"
}

