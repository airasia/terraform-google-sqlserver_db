output "usage_IAM_roles" {
  description = "Basic IAM role(s) that are generally necessary for using the resources in this module. See https://cloud.google.com/iam/docs/understanding-roles."
  value = [
    "roles/cloudsql.client",
  ]
}

output "instance_name" {
  value       = module.google_sqlserver_db.instance_name
  description = "The instance name for the master instance"
}

output "instance_address" {
  value       = module.google_sqlserver_db.instance_address
  description = "The IPv4 addesses assigned for the master instance"
}

output "private_address" {
  value       = module.google_sqlserver_db.private_address
  description = "The private IP address assigned for the master instance"
}

output "instance_first_ip_address" {
  value       = module.google_sqlserver_db.instance_first_ip_address
  description = "The first IPv4 address of the addresses assigned"
}

output "instance_connection_name" {
  value       = module.google_sqlserver_db.instance_connection_name
  description = "The connection name of the master instance to be used in connection strings"
}

output "instance_self_link" {
  value       = module.google_sqlserver_db.instance_self_link
  description = "The URI of the master instance"
}

output "instance_server_ca_cert" {
  value       = module.google_sqlserver_db.instance_server_ca_cert
  description = "The CA certificate information used to connect to the SQL instance via SSL"
}

output "instance_service_account_email_address" {
  value       = module.google_sqlserver_db.instance_service_account_email_address
  description = "The service account email address assigned to the master instance"
}

output "root_user_name" {
  description = "The name of the root user"
  value       = var.root_user_name
}

output "root_user_password" {
  description = "The password of the root user (auto-generated if var.root_user_password was not provided)"
  value       = var.root_user_password != "" ? var.root_user_password : module.google_sqlserver_db.generated_user_password
  sensitive   = true
}

output "additional_users" {
  description = "The additional_users that were passed into this module."
  value       = var.additional_users
}
