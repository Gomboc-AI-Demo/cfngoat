variable company_name {
  description = "Company Name"
  type = string
  default = "acme"
}

variable environment {
  description = "Environment"
  type = string
  default = "dev"
}

variable db_name {
  description = "Name of the Database"
  type = string
  default = "db1"
}

variable password {
  description = "Database Password"
  type = string
}

variable latest_ami_id {
  type = string
  default = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

