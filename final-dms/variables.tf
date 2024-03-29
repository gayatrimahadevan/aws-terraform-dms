################# DMS Variables Start ######################################
variable "environment" {
  description = "dtap environment (DEV/TST/MDL/ACC/PRD)"
  default     = "dev"
}
variable "client_cert" {
  description = "Name of the client certificate for SSL"
  type        = string
  default     ="na"
}
variable "vpc_name" {
  description = "VPC NAME Development/Production/Test/Model"
  default     = "dev-vpc"
}
variable "engine_version" {
  description = "The engine version to use e.g. 9.6"
  default     = "3.4.7"
}
variable "instance_type" {
  description = "replication instance type, e.g dms.t2.medium"
  default     = "dms.t3.medium"
}
variable "instance_size" {
  description = "replication instance size, e.g 30"
  default     = 30
}
variable "region" {
  description = "Region everything is executed in."
  type        = string
  default     = "us-east-1"
}
variable "secret_name" {
  description = "Secret string name"
  type        = string
  default     = "dms-cons"
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
  default     = "na"
}
variable "resource_purpose" {
  description = "provide a discription of what your using this for (tag based on cloud custodian)"
  default     ="na"
}
variable "rts_initiative" {
  description = "Tag for RTSInitiative"
  default     = ""
}
variable "billing_cost_center" {
  description = "provide a cost center for billing reporting (tag based on cloud custodian)"
  default     ="na"
}
variable "agt_managed" {
  description = "Whether AGT manages patching and other things (tag based on cloud custodian) (true or false)"
  default     = "true"
}
variable "primary_lob" {
  description = "Primary line of Business"
  type        = string
  default     = "na"
}
variable "secondary_lob" {
  description = "Secondary line of Business"
  type        = string
  default     = "na"
}
variable "division" {
  description = "Division responsible for instance (tag based on cloud custodian)"
  default     = "na" 
}
variable "resource_contact" {
  description = "provide an email for contacting (tag based on cloud custodian)"
  default     = "na"
}
variable "jenkins_job" {
  description = "Jenkins Job URL"
  type        = string
  default     = "na"
}
variable "channel" {
  description = "Tag for channel"
  default     = ""
}
variable "bitbucket_repo" {
  description = "Bit Bucket repository URL"
  type        = string
  default     = "na"
}
################# Tag Variables End ######################################
