locals {
  endpoints = jsondecode(data.aws_secretsmanager_secret_version.dms-con-details.secret_string)
}

resource "aws_dms_certificate" "dms-client-certificate" {
  certificate_id     = "dms-client-certificate-${lower(var.environment)}"
  certificate_wallet = filebase64("./userdata/${lower(var.client_cert)}")
  #tags = merge(
  #  {
  #    "Name" = "dms-client-certificate-${lower(var.environment)}"
  #  },
  #  module.label.tags
  #)
}
######################  DMS Module     #################################
module "dms-eb-portal" {
  source           = "../modules/dms"
  vpc_name         = var.vpc_name
  instance_size    = var.instance_size
  engine_version   = var.engine_version
  instance_type    = var.instance_type
  application_tag  = var.application_tag
  environment      = var.environment
  resource_contact = var.resource_contact
  resource_purpose = var.resource_purpose
  additional_tags  = var.additional_tags
  agt_managed      = var.agt_managed
  bitbucket_repo   = var.bitbucket_repo
  jenkins_job      = var.jenkins_job
  primary_lob      = var.primary_lob
  rts_initiative   = var.rts_initiative
  secondary_lob    = var.secondary_lob
  tasks = {
    mssql-pg = {
      task_settings       = file("./userdata/task-settings-from-mssql-to-pg.json")
      mappings            = data.template_file.table-mappings-from-mssql-to-pg.rendered
      #migrationtype       = "full-load"
      migrationtype       = "full-load-and-cdc"
      source_endpoint_arn = "sqlserver-source"
      target_endpoint_arn = "postgres-sqlserver-target"
    },
    oracle-pg = {
      task_settings       = file("./userdata/task-settings-from-oracle-to-pg.json")
      mappings            = data.template_file.table-mappings-from-oracle-to-pg.rendered
      migrationtype       = "full-load-and-cdc"
      source_endpoint_arn = "oracle-source"
      target_endpoint_arn = "postgres-oracle-target"
    }
  }
  endpoints = {
    sqlserver-source = {
      endpoint_type     = "source"
      engine_type       = "sqlserver"
      database_name     = local.endpoints["sqlserver-source"].database_name
      database_username = local.endpoints["sqlserver-source"].database_username
      database_password = local.endpoints["sqlserver-source"].database_password
      database_host     = local.endpoints["sqlserver-source"].database_host
      database_port     = local.endpoints["sqlserver-source"].database_port
      ssl_mode          = "none"
      #certificate_arn                    = string
    },
    postgres-sqlserver-target = {
      endpoint_type     = "target"
      engine_type       = "aurora-postgresql"
      database_host     = local.endpoints["postgres-sqlserver-target"].database_host
      database_name     = local.endpoints["postgres-sqlserver-target"].database_name
      database_username = local.endpoints["postgres-sqlserver-target"].database_username
      database_password = local.endpoints["postgres-sqlserver-target"].database_password
      database_port     = local.endpoints["postgres-sqlserver-target"].database_port
      ssl_mode          = "none"
    },
    postgres-oracle-target = {
      endpoint_type     = "target"
      engine_type       = "aurora-postgresql"
      database_host     = local.endpoints["postgres-oracle-target"].database_host
      database_name     = local.endpoints["postgres-oracle-target"].database_name
      database_username = local.endpoints["postgres-oracle-target"].database_username
      database_password = local.endpoints["postgres-oracle-target"].database_password
      database_port     = local.endpoints["postgres-oracle-target"].database_port
      ssl_mode          = "none"
    },
    oracle-source = {
      endpoint_type     = "source"
      engine_type       = "oracle"
      database_name     = local.endpoints["oracle-source"].database_name
      database_username = local.endpoints["oracle-source"].database_username
      database_password = local.endpoints["oracle-source"].database_password
      database_host     = local.endpoints["oracle-source"].database_host
      database_port     = local.endpoints["oracle-source"].database_port
      ssl_mode          = "none"
    }
  }
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
