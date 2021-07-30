variable "region" {
  description = "Region everything is executed in."
  default     = "us-east-1"
}
variable "engine_version" {
  description = "The engine version to use e.g. 3.4.3"
  default     = "3.4.4"
}
variable "instance_type" {
  description = "replication instance size, e.g dms.t2.medium"
  default     = "dms.t3.medium"
}
variable "targetdb" {
  description = "DMS target db host"
  default     = "db-ebportal.cs46pp7ymrlq.us-east-1.rds.amazonaws.com"
}
variable "dbserver" {
  description = "Db host"
  default     = "54.224.171.54"
}
