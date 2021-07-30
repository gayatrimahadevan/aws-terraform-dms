################# DMS Variables Start ######################################
variable "environment" {
  description = "Environment (DEV/TST/MDL/PRD)"
  default     = "DEV"
}
variable "engine_version" {
  description = "The engine version to use e.g. 9.6"
  default     = "3.4.4"
}
variable "instance_type" {
  description = "replication instance type, e.g dms.t2.medium"
  default     = "dms.t2.medium"
}
variable "instance_size" {
  description = "replication instance size, e.g 30"
  default     = 30
}
variable "tasks" {
  description = "list of DMS tasks on a given  instance"
  type        = map(object({
    task_settings       = string
    mappings            = string
    migrationtype       = string
    source_endpoint_arn = string
    target_endpoint_arn = string
  }))
}
variable "endpoints" {
  description = "list of endpoins"
  type        = map(object({
    endpoint_type                      = string
    engine_type                        = string    
    database_host                      = string
    database_name                      = string 
    database_username                  = string
    database_password                  = string
    database_port                      = number
    ssl_mode                           = string
  #  certificate_arn                    = string
  }))
}
variable "vpc_name" {
  description = "VPC NAME Development/Production/Test/Model"
}
################# DMS Variables End ########################################
################# Tag Variables Start ######################################
variable "additional_tags" {
  type        = map(string)
  description = "A mapping of additional tags to assign to the resource"
  default     = {}
}
variable "application_tag" {
  description = "The application/team that the resource is used for"
}
variable "agt_managed" {
  description = "Whether AGT manages patching and other things (tag based on cloud custodian) (true or false)"
  default     = "true"
}
variable "bitbucket_repo" {
  description = "Bit Bucket repository URL"
  type        = string
}
variable "jenkins_job" {
  description = "Jenkins Job URL"
  type        = string
}
variable "primary_lob" {
  description = "Primary line of Business"
  type        = string
}
variable "resource_contact" {
  description = "provide an email for contacting (tag based on cloud custodian)"
}
variable "resource_purpose" {
  description = "provide a discription of what your using this for (tag based on cloud custodian)"
}
variable "rts_initiative" {
  description = "Tag for RTSInitiative"
  default     = ""
}
variable "secondary_lob" {
  description = "Secondary line of Business"
  type        = string
}
################# Tag Variables End ######################################
