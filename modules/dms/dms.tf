# Create a new replication subnet group
resource "aws_dms_replication_subnet_group" "replication-subnet-group" {
  replication_subnet_group_description = "Replication subnet group for DMS."
  replication_subnet_group_id          = "dms-subnet-group-${var.environment}"
  subnet_ids                           = data.aws_subnets.private.ids  
#  tags = merge(
#    module.label.tags
#  )
}
# Create a new replication instance
resource "aws_dms_replication_instance" "replication-instance" {
  allocated_storage           = var.instance_size
  apply_immediately           = true
  auto_minor_version_upgrade  = true
  engine_version              = var.engine_version
  publicly_accessible         = false
  replication_instance_class  = var.instance_type
  replication_instance_id     = "dms-replication-instance-${var.environment}"
  replication_subnet_group_id = aws_dms_replication_subnet_group.replication-subnet-group.id
 # tags = merge(
 #   {
 #     Name = "dms-replication-instance-${var.environment}"
 #   },
 #   module.label.tags
 # )
}
# Create a new replication task
resource "aws_dms_replication_task" "dms-replication-task" {
  for_each                  = var.tasks
  replication_instance_arn  = aws_dms_replication_instance.replication-instance.replication_instance_arn
  replication_task_id       = "dms-replication-task-${each.key}-${var.environment}"
  replication_task_settings =  each.value["task_settings"]
  table_mappings            = each.value["mappings"]
  migration_type            = each.value["migrationtype"]
  source_endpoint_arn       = aws_dms_endpoint.dms-endpoint[each.value.source_endpoint_arn].endpoint_arn
  target_endpoint_arn       = aws_dms_endpoint.dms-endpoint[each.value.target_endpoint_arn].endpoint_arn
  #tags = merge(
  #  {
  #    Name = "dms-replication-task-${each.key}-${var.environment}"
  #  },
  #  module.label.tags
  #)
}
resource "aws_dms_endpoint" "dms-endpoint" {
  for_each                    = var.endpoints
  endpoint_id                 = "dms-endpoint-${each.key}-${var.environment}"
  endpoint_type               = each.value["endpoint_type"]
  engine_name                 = each.value["engine_type"]  
  server_name                 = each.value["database_host"]
  database_name               = each.value["database_name"]
  username                    = each.value["database_username"]
  password                    = each.value["database_password"]
  port                        = each.value["database_port"]
  ssl_mode                    = each.value["ssl_mode"]
  extra_connection_attributes = each.value["extra_connection_attributes"]
  #certificate_arn             = each.value["certificate_arn"]
  #tags = merge(
  #  {
  #    Name = "dms-endpoint-${each.key}-${var.environment}"
  #  },
  #  module.label.tags
  #)  
}
######################  Tags Module     ################################
#module "label" {
#  source           = "git::http://bitbucket.us.aegon.com/scm/twcm/transamerica.workplace.cloud.submodule.mapdatatype.tags.git"
#  additional_tags  = var.additional_tags
#  application_tag  = var.application_tag
#  agt_managed      = var.agt_managed
#  bitbucket_repo   = var.bitbucket_repo
#  environment      = var.environment
#  jenkins_job      = var.jenkins_job
#  primary_lob      = var.primary_lob
#  resource_contact = var.resource_contact
#  resource_purpose = var.resource_purpose
#  rts_initiative   = var.rts_initiative
#  secondary_lob    = var.secondary_lob
#}
