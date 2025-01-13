resource "aws_db_subnet_group" "triaina_db_subnet_group" {
  name       = "triaina-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "Triaina DB Subnet Group"
  }
}

resource "aws_db_instance" "triaina_db" {
  identifier        = "triaina-db"
  allocated_storage = 20
  engine            = "postgres"
  engine_version    = 17.2
  instance_class    = "db.t4g.micro"
  storage_type      = "gp3"
  db_name           = "triaina"
  username          = var.db_username
  password          = var.db_password
  port              = 5432

  db_subnet_group_name   = aws_db_subnet_group.triaina_db_subnet_group.name
  vpc_security_group_ids = toset([var.rds_security_group_id])

  backup_retention_period = 7                     # Number of days to retain automated backups
  backup_window           = "03:00-04:00"         # Preferred UTC backup window (hh24:mi-hh24:mi format)
  maintenance_window      = "mon:04:30-mon:05:00" # Preferred UTC maintenance window

  # Enable automated backups
  skip_final_snapshot       = false
  final_snapshot_identifier = "triaina-db-snap-${timestamp()}"
  deletion_protection       = false

  performance_insights_enabled          = true
  performance_insights_retention_period = 7
  
  # For High Availability
  multi_az = true

  depends_on = [aws_db_subnet_group.triaina_db_subnet_group]
}

## To scale reads create an instance replica
