# ----------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# ----------------------------------------------------------------------------------------------------------------------

variable "name_suffix" {
  description = "An arbitrary suffix that will be added to the end of the resource name(s). For example: an environment name, a business-case name, a numeric id, etc."
  type        = string
  validation {
    condition     = length(var.name_suffix) <= 14
    error_message = "A max of 14 character(s) are allowed."
  }
}

variable "private_network" {
  description = "A VPC network (self-link) that can access the SQLServer instance via private IP. Can set to \"null\" if \"var.public_access\" is set to \"true\"."
  type        = string
}

# ----------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# ----------------------------------------------------------------------------------------------------------------------

variable "user_name" {
  description = "The name of the default database user."
  type        = string
  default     = "default"
}

variable "name" {
  description = "Portion of name to be generated for the instance. The same name of a deleted instance cannot be reused for up to 7 days. See https://cloud.google.com/sql/docs/sqlserver/delete-instance > notes."
  type        = string
  default     = "v1"
}

variable "db_version" {
  description = "The SQLServer database version to use. Options are SQLSERVER_2017_STANDARD, SQLSERVER_2017_ENTERPRISE, SQLSERVER_2017_EXPRESS, or SQLSERVER_2017_WEB. See https://cloud.google.com/sql/docs/sqlserver/db-versions."
  type        = string
  default     = "SQLSERVER_2017_STANDARD"
}

variable "db_charset" {
  description = "The charset for the SQLServer database."
  type        = string
  default     = ""
}

variable "db_collation" {
  description = "The collation for the SQLServer database. See https://docs.microsoft.com/en-us/sql/relational-databases/collations/collation-and-unicode-support?view=sql-server-ver15#Server-level-collations"
  type        = string
  default     = "SQL_Latin1_General_CP1_CI_AS"
}

variable "instance_size" {
  description = "The machine type/size of instance. See https://cloud.google.com/sql/docs/sqlserver/create-instance#machine-types for accepted SQLServer instance types. Choose a corresponding value from the 'API tier string' column."
  type        = string
  default     = "db-custom-1-3840"
}

variable "disk_size_gb" {
  description = "Disk size for the instance in Giga Bytes."
  type        = string
  default     = 10
}

variable "disk_auto_resize" {
  description = "Whether to increase disk storage size of the instance automatically. Increased storage size is permanent. Google charges by storage size whether that storage size is utilized or not. Recommended to set to \"true\" for production workloads."
  type        = bool
  default     = false
}

variable "backup_enabled" {
  description = "Specify whether backups should be enabled for the SQLServer instance."
  type        = bool
  default     = false
}

variable "binary_log_enabled" {
  description = "Specify whether binary logs should be enabled for the SQLServer instance. Value of 'true' requires 'var.backup_enabled' to be 'true'."
  type        = bool
  default     = false
}

variable "pit_recovery_enabled" {
  description = "Specify whether Point-In-Time recoevry should be enabled for the SQLServer instance. It uses the \"binary log\" feature of CloudSQL. Value of 'true' requires 'var.binary_log_enabled' to be 'true'."
  type        = bool
  default     = false
}

variable "highly_available" {
  description = "Whether the SQLServer instance should be highly available (REGIONAL) or single zone (ZONAL). Highly Available (HA) instances will automatically fail-over to another zone within the region if there is an outage of the primary zone. HA instances are recommended for production use-cases and increase cost. Value of 'true' requires 'var.pit_recovery_enabled' to be 'true'."
  type        = bool
  default     = false
}

variable "authorized_networks" {
  description = "External networks that can access the SQLServer instance through HTTPS."
  type = list(object({
    display_name = string
    cidr_block   = string
  }))
  default = []
}

variable "zone" {
  description = "The zone-letter to launch the instance in. Options are \"a\" or \"b\" or \"c\" or \"d\". Defaults to \"a\" zone of the Google provider's region if nothing is specified here. See https://cloud.google.com/compute/docs/regions-zones."
  type        = string
  default     = "a"
}

variable "public_access" {
  description = "Whether public IPv4 address should be assigned to the SQLServer instance. If set to 'false' then 'var.private_network' must be defined."
  type        = bool
  default     = false
}

variable "db_flags" {
  description = "The database flags applied to the instance. See https://cloud.google.com/sql/docs/sqlserver/flags"
  type        = map(string)
  default     = {}
}

variable "user_labels" {
  description = "Key/value labels for the instance."
  type        = map(string)
  default     = {}
}

variable "db_name" {
  description = "Name of the default database to be created."
  type        = string
  default     = "default"
}

variable "db_timeout" {
  description = "How long a database operation is allowed to take before being considered a failure."
  type        = string
  default     = "15m"
}

variable "sql_proxy_user_groups" {
  description = "List of usergroup emails that maybe allowed to connect with the database using CloudSQL Proxy. Connecting via CLoudSQL proxy from remote/localhost requires \"var.public_access\" to be set to \"true\". See https://cloud.google.com/sql/docs/sqlserver/sql-proxy#what_the_proxy_provides"
  type        = list(string)
  default     = []
}
