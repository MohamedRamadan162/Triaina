resource "aws_db_instance" "users" {
  identifier        = "triaina-user-db"
  allocated_storage = 20
  engine            = "postgres"
  engine_version    = 17.2
  instance_class    = "db.t4g.micro"
  storage_type      = "gp2"
  db_name           = "users"
  username          = var.db_username
  password          = var.db_password
  port              = 4512

  db_subnet_group_name   = var.private_subnet_group_name
  vpc_security_group_ids = [var.rds_security_group_id]

  backup_retention_period = 7                     # Number of days to retain automated backups
  backup_window           = "03:00-04:00"         # Preferred UTC backup window (hh24:mi-hh24:mi format)
  maintenance_window      = "mon:04:30-mon:05:00" # Preferred UTC maintenance window

  # Enable automated backups
  skip_final_snapshot       = false
  final_snapshot_identifier = "db-snap"
}

