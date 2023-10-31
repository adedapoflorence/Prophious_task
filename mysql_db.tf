provider "aws" {
  region = "us-east-2"
}

resource "aws_db_instance" "mysql_db" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "mysql-db"
  username             = "db_username"
  password             = "db_password"
  parameter_group_name = "default.mysql5.7"

  # Security group and subnet group for VPC
  vpc_security_group_ids = [aws_security_group.mysql_db.id]
  subnet_group_name     = aws_db_subnet_group.mysql_db_subnet_group.name
}

resource "aws_security_group" "mysql_db" {
  name        = "mysql-db-sg"
  description = "MySQL database security group"
  
  # Define your inbound rules
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Adjust for your security requirements
  }
}

resource "aws_db_subnet_group" "mysql_db_subnet_group" {
  name       = "mysql-db-subnet-group"
  description = "Subnet group for MySQL database"
  
  subnet_ids = ["subnet-ID_1", "subnet-ID_2"]
}
