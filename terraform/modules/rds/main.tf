resource "aws_db_subnet_group" "db-subnet-group" {
  name       = "db-subnet"
  subnet_ids = var.private_subnet_ids
  tags = {
    Name = "DB Subnet Group"
  }
}

resource "aws_db_instance" "user" {
  allocated_storage = 20
  engine            = "postgres"
  engine_version    = 17.2
  instance_class    = "db.t4g.micro"
  storage_type      = "gp2"
  username          = var.user_db_username
  password          = var.user_db_password

  db_subnet_group_name   = aws_db_subnet_group.db-subnet-group.name
  vpc_security_group_ids = [var.rds_security_group_id]

  backup_retention_period = 7                     # Number of days to retain automated backups
  backup_window           = "03:00-04:00"         # Preferred UTC backup window (hh24:mi-hh24:mi format)
  maintenance_window      = "mon:04:30-mon:05:00" # Preferred UTC maintenance window

  # Enable automated backups
  skip_final_snapshot       = false
  final_snapshot_identifier = "db-snap"
}

