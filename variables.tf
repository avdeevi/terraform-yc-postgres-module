variable "name" {
type = string
}
variable "type" {
type = string
}
variable "network_id" {
type = string
}
variable "folder_id"   {
type = string
}
variable "pg_version"   {
type = string
}
variable "autofailover"   {
type = bool
}
variable "backup_hour"   {
type = string
}
variable "backup_minutes"   {
type = string
}
variable "resource_preset"   {
type = string
}
variable "disk_size"   {
type = number
}
variable "databases"   {
type = list
}
variable "extension_name"   {
type = string
default = ""
}
variable "env" {
type  = string
}

variable "node_num" {
type = number
default = 1
}

variable "users" {
 type = list
}

variable "pool_discard" {
type = bool
default = false
}

variable "pooling_mode" {
type = string
default = "SESSION"
}

variable "subnet_index" {
  type = string
  default = ""
}

