// Cloning Terraform src code to /var/folders/ly/1k1ptrtx3x34kw_vbx0698m80000gn/T/terraform_src...
 code has been checked out.

data "aws_caller_identity" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

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

resource "aws_ec2_instance_state" "ec2_instance" {
  // CF Property(AvailabilityZone) = element(data.aws_availability_zones.available.names, 0)
  instance_id = "t2.nano"
  // CF Property(SecurityGroupIds) = [
  //   aws_security_group.web_node_sg.arn
  // ]
  // CF Property(ImageId) = var.latest_ami_id
  // CF Property(SubnetId) = aws_subnet.web_subnet.id
  // CF Property(UserData) = base64encode("#!/bin/bash
  // sudo yum -y update
  // sudo yum -y install httpd php php-mysqlnd
  // sudo systemctl enable httpd
  // sudo systemctl start httpd
  // export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMAAA
  // export AWS_SECRET_ACCESS_KEY=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
  // export AWS_DEFAULT_REGION=us-west-2
  // echo "<h1>Deployed via CloudFormation</h1>" | sudo tee /var/www/html/index.html
  // ")
  // CF Property(tags) = {
  //   Name = "${data.aws_caller_identity.current.account_id}-${var.company_name}-${var.environment}-ec2"
  //   yor_trace = "595b9b79-bd1e-45fd-a297-d521ebdf15e7"
  //   git_org = "bridgecrewio"
  //   git_repo = "cfngoat"
  //   git_file = "cfngoat.yaml"
  //   git_commit = "42153ba22c28f5c0bff388b24a6344137a5dfe26"
  //   git_modifiers = "jonathan.jozwiak/nimrodkor"
  //   git_last_modified_at = "2021-08-23 13:51:41"
  //   git_last_modified_by = "nimrodkor@gmail.com"
  // }
}

resource "aws_ebs_volume" "web_host_storage" {
  availability_zone = element(// Unable to resolve Fn::GetAZs with value: "" because cannot access local variable 'az_data' where it is not associated with a value, 0)
  size = 1
  tags = {
    Name = "${data.aws_caller_identity.current.account_id}-${var.company_name}-${var.environment}-ebs"
    git_last_modified_by = "nimrodkor@gmail.com"
    yor_trace = "838685b6-8fac-42eb-9cf4-008dd36216a1"
    git_org = "bridgecrewio"
    git_repo = "cfngoat"
    git_file = "cfngoat.yaml"
    git_commit = "42153ba22c28f5c0bff388b24a6344137a5dfe26"
    git_modifiers = "jonathan.jozwiak/nimrodkor"
    git_last_modified_at = "2021-08-23 13:51:41"
  }
}

resource "aws_volume_attachment" "ebs_attachment" {
  instance_id = aws_ec2_instance_state.ec2_instance.id
  volume_id = aws_ebs_volume.web_host_storage.id
  device_name = "/dev/sdh"
}

resource "aws_security_group" "web_node_sg" {
  name = "${data.aws_caller_identity.current.account_id}-${var.company_name}-${var.environment}-sg"
  description = "${data.aws_caller_identity.current.account_id}-${var.company_name}-${var.environment} Security Group"
  vpc_id = aws_vpc.web_vpc.arn
  ingress = [
    {
      protocol = "tcp"
      from_port = 80
      to_port = 80
      cidr_blocks = "0.0.0.0/0"
    },
    {
      protocol = "tcp"
      from_port = 22
      to_port = 22
      cidr_blocks = "0.0.0.0/0"
    },
    {
      protocol = "-1"
      from_port = 0
      to_port = 0
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  tags = {
    git_repo = "cfngoat"
    git_file = "cfngoat.yaml"
    git_commit = "42153ba22c28f5c0bff388b24a6344137a5dfe26"
    git_modifiers = "jonathan.jozwiak/nimrodkor"
    git_last_modified_at = "2021-08-23 13:51:41"
    git_last_modified_by = "nimrodkor@gmail.com"
    yor_trace = "d4d72008-2b73-4635-9df6-8035c8850d66"
    git_org = "bridgecrewio"
  }
}

resource "aws_vpc" "web_vpc" {
  cidr_block = "172.16.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "${data.aws_caller_identity.current.account_id}-${var.company_name}-${var.environment}-vpc"
    git_org = "bridgecrewio"
    git_repo = "cfngoat"
    git_file = "cfngoat.yaml"
    git_commit = "b1681f3806db6656faf4107ceceb77e9364e59b7"
    git_modifiers = "jonathan.jozwiak"
    git_last_modified_at = "2020-04-25 01:13:26"
    git_last_modified_by = "jonathan.jozwiak@googlemail.com"
    yor_trace = "eeb90d09-d35e-440f-ac67-2f96e472b2e0"
  }
}

resource "aws_subnet" "web_subnet" {
  vpc_id = aws_vpc.web_vpc.arn
  cidr_block = "172.16.10.0/24"
  availability_zone = element(// Unable to resolve Fn::GetAZs with value: "" because cannot access local variable 'az_data' where it is not associated with a value, 0)
  map_public_ip_on_launch = true
  tags = {
    Name = "${data.aws_caller_identity.current.account_id}-${var.company_name}-${var.environment}-subnet"
    yor_trace = "4f6434ca-b2c2-4fe3-88fc-9ad969965958"
    git_org = "bridgecrewio"
    git_repo = "cfngoat"
    git_file = "cfngoat.yaml"
    git_commit = "42153ba22c28f5c0bff388b24a6344137a5dfe26"
    git_modifiers = "jonathan.jozwiak/nimrodkor"
    git_last_modified_at = "2021-08-23 13:51:41"
    git_last_modified_by = "nimrodkor@gmail.com"
  }
}

resource "aws_subnet" "web_subnet2" {
  vpc_id = aws_vpc.web_vpc.arn
  cidr_block = "172.16.11.0/24"
  availability_zone = element(// Unable to resolve Fn::GetAZs with value: "" because cannot access local variable 'az_data' where it is not associated with a value, 1)
  map_public_ip_on_launch = true
  tags = {
    Name = "${data.aws_caller_identity.current.account_id}-${var.company_name}-${var.environment}-subnet2"
    git_modifiers = "jonathan.jozwiak/nimrodkor"
    git_last_modified_at = "2021-08-23 13:51:41"
    git_last_modified_by = "nimrodkor@gmail.com"
    yor_trace = "68c27f34-7110-458d-98b3-b9a7307638dc"
    git_org = "bridgecrewio"
    git_repo = "cfngoat"
    git_file = "cfngoat.yaml"
    git_commit = "42153ba22c28f5c0bff388b24a6344137a5dfe26"
  }
}

resource "aws_internet_gateway" "web_igw" {
  tags = {
    Name = "${data.aws_caller_identity.current.account_id}-${var.company_name}-${var.environment}-igw"
    yor_trace = "39d8202d-7126-40dd-afa0-4554eeadada4"
    git_org = "bridgecrewio"
    git_repo = "cfngoat"
    git_file = "cfngoat.yaml"
    git_commit = "b1681f3806db6656faf4107ceceb77e9364e59b7"
    git_modifiers = "jonathan.jozwiak"
    git_last_modified_at = "2020-04-25 01:13:26"
    git_last_modified_by = "jonathan.jozwiak@googlemail.com"
  }
}

resource "aws_vpn_gateway_attachment" "internet_gateway_attachment" {
  vpc_id = aws_vpc.web_vpc.arn
}

resource "aws_route_table" "web_rtb" {
  vpc_id = aws_vpc.web_vpc.arn
  tags = {
    Name = "${data.aws_caller_identity.current.account_id}-${var.company_name}-${var.environment}-rtb"
    git_commit = "b1681f3806db6656faf4107ceceb77e9364e59b7"
    git_modifiers = "jonathan.jozwiak"
    git_last_modified_at = "2020-04-25 01:13:26"
    git_last_modified_by = "jonathan.jozwiak@googlemail.com"
    yor_trace = "0613f2a9-ccbb-4e77-839b-bc0a7681bd9c"
    git_org = "bridgecrewio"
    git_repo = "cfngoat"
    git_file = "cfngoat.yaml"
  }
}

resource "aws_route" "web_default_public_route" {
  route_table_id = aws_route_table.web_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.web_igw.id
}

resource "aws_route_table_association" "rtb_assoc" {
  subnet_id = aws_subnet.web_subnet.id
  route_table_id = aws_route_table.web_rtb.id
}

resource "aws_route_table_association" "rtb_assoc2" {
  subnet_id = aws_subnet.web_subnet2.id
  route_table_id = aws_route_table.web_rtb.id
}

resource "aws_network_interface" "web_eni" {
  description = "A nice description."
  subnet_id = aws_subnet.web_subnet.id
  private_ips = "172.16.10.100"
  tags = {
    Name = "${data.aws_caller_identity.current.account_id}-${var.company_name}-${var.environment}-primary_network_interface"
    git_last_modified_by = "jonathan.jozwiak@googlemail.com"
    yor_trace = "ebfdc86d-55a5-4df1-88fd-2f3bc869549c"
    git_org = "bridgecrewio"
    git_repo = "cfngoat"
    git_file = "cfngoat.yaml"
    git_commit = "b1681f3806db6656faf4107ceceb77e9364e59b7"
    git_modifiers = "jonathan.jozwiak"
    git_last_modified_at = "2020-04-25 01:13:26"
  }
}

resource "aws_flow_log" "vpc_flow_logs" {
  eni_id = aws_vpc.web_vpc.arn
  log_destination_type = "s3"
  log_destination = aws_s3_bucket.flow_bucket.arn
  traffic_type = "ALL"
  tags = {
    git_last_modified_at = "2020-04-25 01:13:26"
    git_last_modified_by = "jonathan.jozwiak@googlemail.com"
    yor_trace = "077d3a3d-66bc-4fe9-8839-b59a40785234"
    git_org = "bridgecrewio"
    git_repo = "cfngoat"
    git_file = "cfngoat.yaml"
    git_commit = "b1681f3806db6656faf4107ceceb77e9364e59b7"
    git_modifiers = "jonathan.jozwiak"
  }
}

resource "aws_s3_bucket" "flow_bucket" {
  bucket = "${data.aws_caller_identity.current.account_id}-${var.company_name}-${var.environment}-flowlogs"
  tags = {
    Name = "${data.aws_caller_identity.current.account_id}-${var.company_name}-${var.environment}-flowlogs"
    yor_trace = "a148a687-a031-4491-8fc9-6bb78fef0572"
    git_org = "bridgecrewio"
    git_repo = "cfngoat"
    git_file = "cfngoat.yaml"
    git_commit = "42153ba22c28f5c0bff388b24a6344137a5dfe26"
    git_modifiers = "jonathan.jozwiak/nimrodkor"
    git_last_modified_at = "2021-08-23 13:51:41"
    git_last_modified_by = "nimrodkor@gmail.com"
  }
}

resource "aws_iam_user" "user" {
  name = "${data.aws_caller_identity.current.account_id}-${var.company_name}-${var.environment}-user"
  tags = {
    Name = "${data.aws_caller_identity.current.account_id}-${var.company_name}-${var.environment}-user"
    Environment = "${data.aws_caller_identity.current.account_id}-${var.company_name}-${var.environment}"
    git_last_modified_at = "2021-08-23 13:51:41"
    git_last_modified_by = "nimrodkor@gmail.com"
    yor_trace = "346804e2-5a21-4f1b-a8bf-f3c3fc9c7d15"
    git_org = "bridgecrewio"
    git_repo = "cfngoat"
    git_file = "cfngoat.yaml"
    git_commit = "42153ba22c28f5c0bff388b24a6344137a5dfe26"
    git_modifiers = "jonathan.jozwiak/nimrodkor"
  }
}

resource "aws_iam_access_key" "access_key" {
  user = aws_iam_user.user.arn
}

resource "aws_iam_policy" "user_policy" {
  name = "excess_policy"
  policy = {
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:*",
          "s3:*",
          "lambda:*",
          "cloudwatch:*"
        ]
        Resource = "*"
      }
    ]
  }
  // CF Property(Users) = [
  //   aws_iam_user.user.arn
  // ]
}

resource "aws_kms_key" "logs_key" {
  description = "${data.aws_caller_identity.current.account_id}-${var.company_name}-${var.environment}-logs bucket key"
  deletion_window_in_days = 7
  policy = {
    Version = "2012-10-17"
    Id = "key-default-1"
    Statement = [
      {
        Sid = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action = "kms:*"
        Resource = "*"
      }
    ]
  }
  tags = {
    git_modifiers = "jonathan.jozwiak/nimrodkor"
    git_last_modified_at = "2021-08-23 13:51:41"
    git_last_modified_by = "nimrodkor@gmail.com"
    yor_trace = "bd68272a-4d3b-44e6-a2f0-ad783935c332"
    git_org = "bridgecrewio"
    git_repo = "cfngoat"
    git_file = "cfngoat.yaml"
    git_commit = "42153ba22c28f5c0bff388b24a6344137a5dfe26"
  }
}

resource "aws_kms_alias" "logs_key_alias" {
  name = "alias/${data.aws_caller_identity.current.account_id}-${var.company_name}-${var.environment}-logs-bucket-key"
  target_key_id = aws_kms_key.logs_key.arn
}

resource "aws_db_instance" "default_db" {
  db_name = var.db_name
  engine = "MySQL"
  option_group_name = aws_db_option_group.default_db_option_group.id
  parameter_group_name = aws_db_parameter_group.default_db_parameter_group.id
  db_subnet_group_name = aws_db_subnet_group.default_subnet_group.id
  vpc_security_group_ids = [
    aws_security_group.default_sg.arn
  ]
  identifier = "rds-${data.aws_caller_identity.current.account_id}-${var.company_name}-${var.environment}"
  engine_version = "8.0"
  instance_class = "db.t3.micro"
  allocated_storage = "20"
  username = "admin"
  manage_master_user_password = var.password
  multi_az = false
  backup_retention_period = 0
  storage_encrypted = false
  monitoring_interval = 0
  publicly_accessible = true
  tags = {
    Name = "${data.aws_caller_identity.current.account_id}-${var.company_name}-${var.environment}-rds"
    Environment = "${data.aws_caller_identity.current.account_id}-${var.company_name}-${var.environment}"
    git_org = "bridgecrewio"
    git_repo = "cfngoat"
    git_file = "cfngoat.yaml"
    git_commit = "42153ba22c28f5c0bff388b24a6344137a5dfe26"
    git_modifiers = "jonathan.jozwiak/nimrodkor"
    git_last_modified_at = "2021-08-23 13:51:41"
    git_last_modified_by = "nimrodkor@gmail.com"
    yor_trace = "ca176a04-46cc-411d-a062-222ae03835a8"
  }
}

resource "aws_db_option_group" "default_db_option_group" {
  engine_name = "mysql"
  major_engine_version = "8.0"
  option_group_description = "CloudFormation OG"
  option = [
  ]
  tags = {
    Name = "og-${data.aws_caller_identity.current.account_id}-${var.company_name}-${var.environment}"
    Environment = "${data.aws_caller_identity.current.account_id}-${var.company_name}-${var.environment}"
    git_last_modified_by = "nimrodkor@gmail.com"
    yor_trace = "6d7cc8b8-ee12-4ad2-940c-324b6eeca646"
    git_org = "bridgecrewio"
    git_repo = "cfngoat"
    git_file = "cfngoat.yaml"
    git_commit = "42153ba22c28f5c0bff388b24a6344137a5dfe26"
    git_modifiers = "jonathan.jozwiak/nimrodkor"
    git_last_modified_at = "2021-08-23 13:51:41"
  }
}

resource "aws_db_parameter_group" "default_db_parameter_group" {
  description = "Terraform PG"
  family = "mysql8.0"
  parameter = {
    character_set_client = "utf8"
    character_set_server = "utf8"
  }
  tags = {
    Name = "${data.aws_caller_identity.current.account_id}-${var.company_name}-${var.environment}-pg"
    Environment = "${data.aws_caller_identity.current.account_id}-${var.company_name}-${var.environment}"
    git_modifiers = "jonathan.jozwiak/nimrodkor"
    git_last_modified_at = "2021-08-23 13:51:41"
    git_last_modified_by = "nimrodkor@gmail.com"
    yor_trace = "88c3fff0-8627-4e00-8e10-086c1651370a"
    git_org = "bridgecrewio"
    git_repo = "cfngoat"
    git_file = "cfngoat.yaml"
    git_commit = "42153ba22c28f5c0bff388b24a6344137a5dfe26"
  }
}

resource "aws_db_subnet_group" "default_subnet_group" {
  name = "sg-${data.aws_caller_identity.current.account_id}-${var.company_name}-${var.environment}"
  description = "CloudFormation DB Subnet Group"
  subnet_ids = [
    aws_subnet.web_subnet.id,
    aws_subnet.web_subnet2.id
  ]
  tags = {
    Name = "sg-${data.aws_caller_identity.current.account_id}-${var.company_name}-${var.environment}"
    Environment = "${data.aws_caller_identity.current.account_id}-${var.company_name}-${var.environment}"
    git_file = "cfngoat.yaml"
    git_commit = "42153ba22c28f5c0bff388b24a6344137a5dfe26"
    git_modifiers = "jonathan.jozwiak/nimrodkor"
    git_last_modified_at = "2021-08-23 13:51:41"
    git_last_modified_by = "nimrodkor@gmail.com"
    yor_trace = "3c0704d6-7b98-472d-a6b2-c3085cb87024"
    git_org = "bridgecrewio"
    git_repo = "cfngoat"
  }
}

resource "aws_security_group" "default_sg" {
  name = "${data.aws_caller_identity.current.account_id}-${var.company_name}-${var.environment}-rds-sg"
  description = "${data.aws_caller_identity.current.account_id}-${var.company_name}-${var.environment} RDS Security Group"
  vpc_id = aws_vpc.web_vpc.arn
  ingress = [
    {
      protocol = "tcp"
      from_port = 3306
      to_port = 3306
      cidr_blocks = aws_vpc.web_vpc.cidr_block
    }
  ]
  tags = {
    Name = "${data.aws_caller_identity.current.account_id}-${var.company_name}-${var.environment}-rds-sg"
    Environment = "${data.aws_caller_identity.current.account_id}-${var.company_name}-${var.environment}"
    git_org = "bridgecrewio"
    git_repo = "cfngoat"
    git_file = "cfngoat.yaml"
    git_commit = "b1681f3806db6656faf4107ceceb77e9364e59b7"
    git_modifiers = "jonathan.jozwiak"
    git_last_modified_at = "2020-04-25 01:13:26"
    git_last_modified_by = "jonathan.jozwiak@googlemail.com"
    yor_trace = "3d3b2421-0886-4ab8-88ec-e4bef646fdf6"
  }
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${data.aws_caller_identity.current.account_id}-${var.company_name}-${var.environment}-profile"
  path = "/"
  role = [
    aws_iam_role.ec2_role.arn
  ]
}

resource "aws_iam_role" "ec2_role" {
  name = "${data.aws_caller_identity.current.account_id}-${var.company_name}-${var.environment}-role"
  assume_role_policy = {
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = [
            "ec2.amazonaws.com"
          ]
        }
        Action = [
          "sts:AssumeRole"
        ]
      }
    ]
  }
  path = "/"
  tags = {
    Name = "${data.aws_caller_identity.current.account_id}-${var.company_name}-${var.environment}-role"
    Environment = "${data.aws_caller_identity.current.account_id}-${var.company_name}-${var.environment}"
    git_file = "cfngoat.yaml"
    git_commit = "42153ba22c28f5c0bff388b24a6344137a5dfe26"
    git_modifiers = "jonathan.jozwiak/nimrodkor"
    git_last_modified_at = "2021-08-23 13:51:41"
    git_last_modified_by = "nimrodkor@gmail.com"
    yor_trace = "47d128cd-8fec-4d80-a768-e5e4c133b61a"
    git_org = "bridgecrewio"
    git_repo = "cfngoat"
  }
}

resource "aws_iam_policy" "ec2_policy" {
  name = "${data.aws_caller_identity.current.account_id}-${var.company_name}-${var.environment}-policy"
  policy = {
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:*",
          "ec2:*",
          "rds:*"
        ]
        Resource = "*"
      }
    ]
  }
  // CF Property(Roles) = [
  //   aws_iam_role.ec2_role.arn
  // ]
}

resource "aws_ec2_instance_state" "db_app_instance" {
  // CF Property(AvailabilityZone) = element(// Unable to resolve Fn::GetAZs with value: "" because cannot access local variable 'az_data' where it is not associated with a value, 0)
  // CF Property(ImageId) = var.latest_ami_id
  instance_id = aws_iam_instance_profile.ec2_profile.arn
  // CF Property(SecurityGroupIds) = [
  //   aws_security_group.web_node_sg.arn
  // ]
  // CF Property(SubnetId) = aws_subnet.web_subnet.id
  // CF Property(UserData) = base64encode("#!/bin/bash
  // ### Config from https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_Tutorials.WebServerDB.CreateWebServer.html
  // sudo yum -y update
  // sudo yum -y install httpd php php-mysqlnd
  // sudo systemctl enable httpd
  // sudo systemctl start httpd
  // sudo mkdir /var/www/inc
  // cat << EnD > /tmp/dbinfo.inc
  // <?php
  // define('DB_SERVER', '${aws_db_instance.default_db.address}:${aws_db_instance.default_db.port}');
  // define('DB_USERNAME', 'admin');
  // define('DB_PASSWORD', '${var.password}');
  // define('DB_DATABASE', '${aws_db_instance.default_db.address}');
  // ?>
  // EnD
  // sudo mv /tmp/dbinfo.inc /var/www/inc
  // sudo chown root:root /var/www/inc/dbinfo.inc
  // cat << EnD > /tmp/index.php
  // <?php include "../inc/dbinfo.inc"; ?>
  // <html>
  // <body>
  // <h1>Sample page</h1>
  // <?php
  //   /* Connect to MySQL and select the database. */
  //   $connection = mysqli_connect(DB_SERVER, DB_USERNAME, DB_PASSWORD);
  //   if (mysqli_connect_errno()) echo "Failed to connect to MySQL: " . mysqli_connect_error();
  //   $database = mysqli_select_db($connection, DB_DATABASE);
  //   /* Ensure that the EMPLOYEES table exists. */
  //   VerifyEmployeesTable($connection, DB_DATABASE);
  //   /* If input fields are populated, add a row to the EMPLOYEES table. */
  //   $employee_name = htmlentities($_POST['NAME']);
  //   $employee_address = htmlentities($_POST['ADDRESS']);
  //   if (strlen($employee_name) || strlen($employee_address)) {
  //     AddEmployee($connection, $employee_name, $employee_address);
  //   }
  // ?>
  // <!-- Input form -->
  // <form action="<?PHP echo $_SERVER['SCRIPT_NAME'] ?>" method="POST">
  //   <table border="0">
  //     <tr>
  //       <td>NAME</td>
  //       <td>ADDRESS</td>
  //     </tr>
  //     <tr>
  //       <td>
  //         <input type="text" name="NAME" maxlength="45" size="30" />
  //       </td>
  //       <td>
  //         <input type="text" name="ADDRESS" maxlength="90" size="60" />
  //       </td>
  //       <td>
  //         <input type="submit" value="Add Data" />
  //       </td>
  //     </tr>
  //   </table>
  // </form>
  // <!-- Display table data. -->
  // <table border="1" cellpadding="2" cellspacing="2">
  //   <tr>
  //     <td>ID</td>
  //     <td>NAME</td>
  //     <td>ADDRESS</td>
  //   </tr>
  // <?php
  // $result = mysqli_query($connection, "SELECT * FROM EMPLOYEES");
  // while($query_data = mysqli_fetch_row($result)) {
  //   echo "<tr>";
  //   echo "<td>",$query_data[0], "</td>",
  //        "<td>",$query_data[1], "</td>",
  //        "<td>",$query_data[2], "</td>";
  //   echo "</tr>";
  // }
  // ?>
  // </table>
  // <!-- Clean up. -->
  // <?php
  //   mysqli_free_result($result);
  //   mysqli_close($connection);
  // ?>
  // </body>
  // </html>
  // <?php
  // /* Add an employee to the table. */
  // function AddEmployee($connection, $name, $address) {
  //    $n = mysqli_real_escape_string($connection, $name);
  //    $a = mysqli_real_escape_string($connection, $address);
  //    $query = "INSERT INTO EMPLOYEES (NAME, ADDRESS) VALUES ('$n', '$a');";
  //    if(!mysqli_query($connection, $query)) echo("<p>Error adding employee data.</p>");
  // }
  // /* Check whether the table exists and, if not, create it. */
  // function VerifyEmployeesTable($connection, $dbName) {
  //   if(!TableExists("EMPLOYEES", $connection, $dbName))
  //   {
  //      $query = "CREATE TABLE EMPLOYEES (
  //          ID int(11) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  //          NAME VARCHAR(45),
  //          ADDRESS VARCHAR(90)
  //        )";
  //      if(!mysqli_query($connection, $query)) echo("<p>Error creating table.</p>");
  //   }
  // }
  // /* Check for the existence of a table. */
  // function TableExists($tableName, $connection, $dbName) {
  //   $t = mysqli_real_escape_string($connection, $tableName);
  //   $d = mysqli_real_escape_string($connection, $dbName);
  //   $checktable = mysqli_query($connection,
  //       "SELECT TABLE_NAME FROM information_schema.TABLES WHERE TABLE_NAME = '$t' AND TABLE_SCHEMA = '$d'");
  //   if(mysqli_num_rows($checktable) > 0) return true;
  //   return false;
  // }
  // ?>
  // EnD
  // sudo mv /tmp/index.php /var/www/html
  // sudo chown root:root /var/www/html/index.php
  // ")
  // CF Property(tags) = {
  //   Name = "${data.aws_caller_identity.current.account_id}-${var.company_name}-${var.environment}-dbapp"
  //   git_file = "cfngoat.yaml"
  //   git_commit = "42153ba22c28f5c0bff388b24a6344137a5dfe26"
  //   git_modifiers = "jonathan.jozwiak/nimrodkor"
  //   git_last_modified_at = "2021-08-23 13:51:41"
  //   git_last_modified_by = "nimrodkor@gmail.com"
  //   yor_trace = "35854694-8244-4717-8f50-146fbec15c61"
  //   git_org = "bridgecrewio"
  //   git_repo = "cfngoat"
  // }
}

resource "aws_iam_role" "iam4_lambda" {
  name = "${data.aws_caller_identity.current.account_id}-${var.company_name}-${var.environment}-analysis-lambda"
  assume_role_policy = {
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = [
            "lambda.amazonaws.com"
          ]
        }
        Action = [
          "sts:AssumeRole"
        ]
      }
    ]
  }
  path = "/"
  tags = {
    Name = "${data.aws_caller_identity.current.account_id}-${var.company_name}-${var.environment}-analysis-lambda"
    Environment = "${data.aws_caller_identity.current.account_id}-${var.company_name}-${var.environment}"
    git_last_modified_at = "2021-08-23 13:51:41"
    git_last_modified_by = "nimrodkor@gmail.com"
    yor_trace = "2c07712d-22f5-42be-946e-1c2e71d2e275"
    git_org = "bridgecrewio"
    git_repo = "cfngoat"
    git_file = "cfngoat.yaml"
    git_commit = "42153ba22c28f5c0bff388b24a6344137a5dfe26"
    git_modifiers = "jonathan.jozwiak/nimrodkor"
  }
}

resource "aws_lambda_function" "analysis_lambda" {
  function_name = "${data.aws_caller_identity.current.account_id}-${var.company_name}-${var.environment}-analysis"
  runtime = "nodejs12.x"
  role = aws_iam_role.iam4_lambda.arn
  handler = "exports.test"
  code_signing_config_arn = {
    ZipFile = "console.log("Hello World");
"
  }
  environment {
    variables = {
      access_key = "AKIAIOSFODNN7EXAMPLE"
      secret_key = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
    }
  }
  tags = {
    Name = "${data.aws_caller_identity.current.account_id}-${var.company_name}-${var.environment}-analysis"
    Environment = "${data.aws_caller_identity.current.account_id}-${var.company_name}-${var.environment}"
    git_last_modified_by = "nimrodkor@gmail.com"
    yor_trace = "5939cdf9-4e86-4208-80d1-095c367c2c13"
    git_org = "bridgecrewio"
    git_repo = "cfngoat"
    git_file = "cfngoat.yaml"
    git_commit = "42153ba22c28f5c0bff388b24a6344137a5dfe26"
    git_modifiers = "jonathan.jozwiak/nimrodkor"
    git_last_modified_at = "2021-08-23 13:51:41"
  }
}

resource "aws_s3_bucket" "data_bucket" {
  bucket = "${data.aws_caller_identity.current.account_id}-${var.company_name}-${var.environment}-data"
  acl = "public-read"
  tags = {
    Name = "${data.aws_caller_identity.current.account_id}-${var.company_name}-${var.environment}-data"
    git_repo = "cfngoat"
    git_file = "cfngoat.yaml"
    git_commit = "b1681f3806db6656faf4107ceceb77e9364e59b7"
    git_modifiers = "jonathan.jozwiak"
    git_last_modified_at = "2020-04-25 01:13:26"
    git_last_modified_by = "jonathan.jozwiak@googlemail.com"
    yor_trace = "509b197d-4f87-4ae1-aa43-8cca13c9e92e"
    git_org = "bridgecrewio"
  }
}

resource "aws_s3_bucket" "financials_bucket" {
  bucket = "${data.aws_caller_identity.current.account_id}-${var.company_name}-${var.environment}-financials"
  acl = "private"
  tags = {
    Name = "${data.aws_caller_identity.current.account_id}-${var.company_name}-${var.environment}-financials"
    git_file = "cfngoat.yaml"
    git_commit = "b1681f3806db6656faf4107ceceb77e9364e59b7"
    git_modifiers = "jonathan.jozwiak"
    git_last_modified_at = "2020-04-25 01:13:26"
    git_last_modified_by = "jonathan.jozwiak@googlemail.com"
    yor_trace = "7d0b70d4-58fb-4d2d-b966-177d349932da"
    git_org = "bridgecrewio"
    git_repo = "cfngoat"
  }
}

resource "aws_s3_bucket" "operations_bucket" {
  bucket = "${data.aws_caller_identity.current.account_id}-${var.company_name}-${var.environment}-operations"
  versioning {
    // CF Property(Status) = "Enabled"
  }
  acl = "private"
  tags = {
    Name = "${data.aws_caller_identity.current.account_id}-${var.company_name}-${var.environment}-operations"
    git_org = "bridgecrewio"
    git_repo = "cfngoat"
    git_file = "cfngoat.yaml"
    git_commit = "b1681f3806db6656faf4107ceceb77e9364e59b7"
    git_modifiers = "jonathan.jozwiak"
    git_last_modified_at = "2020-04-25 01:13:26"
    git_last_modified_by = "jonathan.jozwiak@googlemail.com"
    yor_trace = "9e00e7c2-b27c-4141-af5a-2d90c9632a23"
  }
}

resource "aws_s3_bucket" "data_science_bucket" {
  bucket = "${data.aws_caller_identity.current.account_id}-${var.company_name}-${var.environment}-data-science"
  versioning {
    // CF Property(Status) = "Enabled"
  }
  logging {
    target_bucket = aws_s3_bucket.logs_bucket.id
    // CF Property(LogFilePrefix) = "log/"
  }
  acl = "private"
  tags = {
    Name = "${data.aws_caller_identity.current.account_id}-${var.company_name}-${var.environment}-data-science"
    git_repo = "cfngoat"
    git_file = "cfngoat.yaml"
    git_commit = "42153ba22c28f5c0bff388b24a6344137a5dfe26"
    git_modifiers = "jonathan.jozwiak/nimrodkor"
    git_last_modified_at = "2021-08-23 13:51:41"
    git_last_modified_by = "nimrodkor@gmail.com"
    yor_trace = "11266986-850e-41eb-b980-7b4d8d49f919"
    git_org = "bridgecrewio"
  }
}

resource "aws_s3_bucket" "logs_bucket" {
  bucket = {
    ServerSideEncryptionConfiguration = [
      {
        ServerSideEncryptionByDefault = {
          KMSMasterKeyID = aws_kms_key.logs_key.arn
          SSEAlgorithm = "aws:kms"
        }
      }
    ]
  }
  versioning {
    // CF Property(Status) = "Enabled"
  }
  acl = "log-delivery-write"
  tags = {
    Name = "${data.aws_caller_identity.current.account_id}-${var.company_name}-${var.environment}-logs"
    yor_trace = "7c5f90f1-7102-45dc-bead-02754df64eba"
    git_org = "bridgecrewio"
    git_repo = "cfngoat"
    git_file = "cfngoat.yaml"
    git_commit = "42153ba22c28f5c0bff388b24a6344137a5dfe26"
    git_modifiers = "jonathan.jozwiak/nimrodkor"
    git_last_modified_at = "2021-08-23 13:51:41"
    git_last_modified_by = "nimrodkor@gmail.com"
  }
}

resource "aws_iam_role" "cleanup_role" {
  assume_role_policy = {
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = [
            "lambda.amazonaws.com"
          ]
        }
        Action = [
          "sts:AssumeRole"
        ]
      }
    ]
  }
  path = "/"
  force_detach_policies = [
    {
      PolicyName = "lambda-execute"
      PolicyDocument = {
        Statement = [
          {
            Effect = "Allow"
            Action = [
              "logs:*"
            ]
            Resource = "*"
          }
        ]
      }
    },
    {
      PolicyName = "s3-object-delete"
      PolicyDocument = {
        Statement = [
          {
            Effect = "Allow"
            Action = [
              "s3:GetObject",
              "s3:ListBucket",
              "s3:DeleteObject"
            ]
            Resource = "*"
          }
        ]
      }
    }
  ]
  tags = {
    Name = "${data.aws_caller_identity.current.account_id}-${var.company_name}-${var.environment}-cleanup-role"
    Environment = "${data.aws_caller_identity.current.account_id}-${var.company_name}-${var.environment}"
    git_file = "cfngoat.yaml"
    git_commit = "b1681f3806db6656faf4107ceceb77e9364e59b7"
    git_modifiers = "jonathan.jozwiak"
    git_last_modified_at = "2020-04-25 01:13:26"
    git_last_modified_by = "jonathan.jozwiak@googlemail.com"
    yor_trace = "573995a2-e3f4-43a6-847d-df474b0fc71a"
    git_org = "bridgecrewio"
    git_repo = "cfngoat"
  }
}

resource "aws_lambda_function" "clean_bucket_function" {
  handler = "index.clearS3Bucket"
  role = aws_iam_role.cleanup_role.arn
  runtime = "nodejs12.x"
  timeout = 25
  code_signing_config_arn = {
    ZipFile = "'use strict';

var AWS      = require('aws-sdk');
var s3       = new AWS.S3();

module.exports =  {
  clearS3Bucket: function (event, context, cb) {
    console.log("Event=", event);
    console.log("Context=", context);
    if (event.RequestType === 'Delete')  {
        var bucketName = event.ResourceProperties.BucketName;

        console.log("Delete bucket requested for", bucketName);

        var objects = listObjects(s3, bucketName);

        objects.then(function(result) {
           var keysToDeleteArray = [];
           console.log("Found "+ result.Contents.length + " objects to delete.");
           if (result.Contents.length === 0) {
               sendResponse(event, context, "SUCCESS");
           } else {
               for (var i = 0, len = result.Contents.length; i < len; i++) {
                   var item =  new Object();
                   item = {};
                   item = { Key: result.Contents[i].Key };
                   keysToDeleteArray.push(item);
               }

               var delete_params = {
                   Bucket: bucketName,
                   Delete: {
                     Objects: keysToDeleteArray,
                     Quiet: false
                   }
               };

               var deletedObjects = deleteObjects(s3, delete_params);

               deletedObjects.then(function(result) {
                   console.log("deleteObjects API returned ", result);
                   sendResponse(event, context, "SUCCESS");
               }, function(err) {
                   console.log("ERROR: deleteObjects API Call failed!");
                   console.log(err);
                   sendResponse(event, context, "FAILED");
               });
           }
        }, function(err) {
           console.log("ERROR: listObjects API Call failed!");
           console.log(err);
           sendResponse(event, context, "FAILED");
        });

    } else {
      console.log("Delete not requested.");
      sendResponse(event, context, "SUCCESS");
    }

  }
};

function listObjects(client, bucketName) {
  return new Promise(function (resolve, reject){
    client.listObjectsV2({Bucket: bucketName}, function (err, res){
      if (err) reject(err);
      else resolve(res);
    });
  });
}

function deleteObjects(client, params) {
  return new Promise(function (resolve, reject){
    client.deleteObjects(params, function (err, res){
      if (err) reject(err);
      else resolve(res);
    });
  });
}

function sendResponse(event, context, responseStatus, responseData, physicalResourceId, noEcho) {
  var responseBody = JSON.stringify({
    Status: responseStatus,
    Reason: "See the details in CloudWatch Log Stream: " + context.logStreamName,
    PhysicalResourceId: physicalResourceId || context.logStreamName,
    StackId: event.StackId,
    RequestId: event.RequestId,
    LogicalResourceId: event.LogicalResourceId,
    NoEcho: noEcho || false,
    Data: responseData
  });

  console.log("Response body:\n", responseBody);

  var https = require("https");
  var url = require("url");

  var parsedUrl = url.parse(event.ResponseURL);
  var options = {
    hostname: parsedUrl.hostname,
    port: 443,
    path: parsedUrl.path,
    method: "PUT",
    headers: {
      "content-type": "",
      "content-length": responseBody.length
    }
  };

  var request = https.request(options, function(response) {
    console.log("Status code: " + response.statusCode);
    console.log("Status message: " + response.statusMessage);
    context.done();
  });

  request.on("error", function(error) {
    console.log("send(..) failed executing https.request(..): " + error);
    context.done();
  });

  request.write(responseBody);
  request.end();
}
"
  }
  tags = {
    git_commit = "42153ba22c28f5c0bff388b24a6344137a5dfe26"
    git_modifiers = "jonathan.jozwiak/nimrodkor"
    git_last_modified_at = "2021-08-23 13:51:41"
    git_last_modified_by = "nimrodkor@gmail.com"
    yor_trace = "75847e0e-ba4e-46e5-8c36-cd934d666acd"
    git_org = "bridgecrewio"
    git_repo = "cfngoat"
    git_file = "cfngoat.yaml"
  }
}

resource "aws_s3control_bucket" "clean_flow_bucket_on_delete" {
  // CF Property(ServiceToken) = aws_lambda_function.clean_bucket_function.arn
  bucket = aws_s3_bucket.flow_bucket.id
}

resource "aws_autoscaling_attachment" "clean_data_bucket_on_delete" {
  // CF Property(ServiceToken) = aws_lambda_function.clean_bucket_function.arn
  autoscaling_group_name = aws_s3_bucket.data_bucket.id
}

resource "aws_customerprofiles_profile" "clean_financials_bucket_on_delete" {
  // CF Property(ServiceToken) = aws_lambda_function.clean_bucket_function.arn
  // CF Property(BucketName) = aws_s3_bucket.financials_bucket.id
}

resource "aws_cloudformation_stack_set" "clean_operations_bucket_on_delete" {
  // CF Property(ServiceToken) = aws_lambda_function.clean_bucket_function.arn
  name = aws_s3_bucket.operations_bucket.id
}

resource "aws_macie2_custom_data_identifier" "clean_data_science_bucket_on_delete" {
  // CF Property(ServiceToken) = aws_lambda_function.clean_bucket_function.arn
  name = aws_s3_bucket.data_science_bucket.id
}

resource "aws_securitylake_custom_log_source" "clean_logs_bucket_on_delete" {
  // CF Property(ServiceToken) = aws_lambda_function.clean_bucket_function.arn
  // CF Property(BucketName) = aws_s3_bucket.logs_bucket.id
}

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
