# Create a new replication subnet group
resource "aws_dms_replication_subnet_group" "replication-subnet-group" {
  replication_subnet_group_description = "Replication subnet group for DMS."
  replication_subnet_group_id          = "dms-subnet-group"
  subnet_ids                           = data.aws_subnet_ids.public.ids
  depends_on                           = [aws_iam_role_policy_attachment.dms-vpc-role-AmazonDMSVPCManagementRole]
}
# Create a new replication instance
resource "aws_dms_replication_instance" "replication-instance" {
  allocated_storage           = 30
  apply_immediately           = true
  auto_minor_version_upgrade  = true
  engine_version              = var.engine_version
  publicly_accessible         = true
  replication_instance_class  = var.instance_type
  replication_instance_id     = "dms-replication-instance"
  replication_subnet_group_id = aws_dms_replication_subnet_group.replication-subnet-group.id
}
# Create a new replication task
resource "aws_dms_replication_task" "rt-mssql-pg" {
  migration_type            = "full-load"
  replication_instance_arn  = aws_dms_replication_instance.replication-instance.replication_instance_arn
  replication_task_id       = "dms-rt-mssql-pg"
  source_endpoint_arn       = aws_dms_endpoint.dms-endpoint-source.endpoint_arn
  target_endpoint_arn       = aws_dms_endpoint.dms-endpoint-target.endpoint_arn
  table_mappings            = data.template_file.table-mappings-from-mssql-to-pg.rendered
  replication_task_settings = file("./userdata/task-settings-from-mssql-to-pg.json")
}
resource "aws_dms_replication_task" "rt-oracle-pg" {
  migration_type            = "full-load"
  replication_instance_arn  = aws_dms_replication_instance.replication-instance.replication_instance_arn
  replication_task_id       = "dms-rt-oracle-pg"
  source_endpoint_arn       = aws_dms_endpoint.dms-endpoint-oracle.endpoint_arn
  target_endpoint_arn       = aws_dms_endpoint.dms-endpoint-targetorcl.endpoint_arn
  table_mappings            = data.template_file.table-mappings-from-oracle-to-pg.rendered
  replication_task_settings = file("./userdata/task-settings-from-oracle-to-pg.json")
}
resource "aws_dms_endpoint" "dms-endpoint-source" {
  endpoint_id   = "dms-endpoint-source"
  endpoint_type = "source"
  engine_name   = "sqlserver"
  server_name   = var.dbserver
  database_name = "AdventureWorksLT2019"
  username      = "dmsuser"
  password      = "deloitte.0"
  port          = "1433"
}
resource "aws_dms_endpoint" "dms-endpoint-oracle" {
  endpoint_id   = "dms-endpoint-oracle"
  endpoint_type = "source"
  engine_name   = "oracle"
  server_name   = var.dbserver
  database_name = "ORCLPDB1"
  username      = "dms_user"
  password      = "deloitte.0"
  port          = "1521"
}
resource "aws_dms_endpoint" "dms-endpoint-target" {
  endpoint_id   = "dms-endpoint-target"
  endpoint_type = "target"
  engine_name   = "aurora-postgresql"
  server_name   = var.targetdb
  database_name = "customerdb"
  username      = "appuser"
  password      = "password02"
  port          = "5432"
}
resource "aws_dms_endpoint" "dms-endpoint-targetorcl" {
  endpoint_id   = "dms-endpoint-targetorcl"
  endpoint_type = "target"
  engine_name   = "aurora-postgresql"
  server_name   = var.targetdb
  database_name = "demodb"
  username      = "appuser"
  password      = "password02"
  port          = "5432"
}
