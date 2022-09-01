terraform {
  required_version = ">= 0.13.1" # see https://releases.hashicorp.com/terraform/
}

locals {
  name_suffix = format("%s-%s", var.name, var.name_suffix)
  authorized_networks = [
    for authorized_network in var.authorized_networks : {
      name  = authorized_network.display_name
      value = authorized_network.cidr_block
    }
  ]
  db_flags       = [for key, val in var.db_flags : { name = key, value = val }]
  default_region = data.google_client_config.google_client.region
  region         = coalesce(var.region, local.default_region)
  zone           = format("%s-%s", local.region, var.zone)
}

data "google_client_config" "google_client" {}

resource "google_project_service" "compute_api" {
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "cloudsql_api" {
  service            = "sqladmin.googleapis.com"
  disable_on_destroy = false
}

module "google_sqlserver_db" {
  source                          = "GoogleCloudPlatform/sql-db/google//modules/mssql"
  version                         = "9.0.0"
  depends_on                      = [google_project_service.compute_api, google_project_service.cloudsql_api]
  deletion_protection             = var.deletion_protection
  project_id                      = data.google_client_config.google_client.project
  name                            = format("sqlserver-%s", local.name_suffix)
  db_name                         = var.default_db_name
  db_collation                    = var.default_db_collation
  db_charset                      = var.default_db_charset
  database_version                = var.db_version
  region                          = local.region
  zone                            = local.zone
  availability_type               = var.highly_available ? "REGIONAL" : "ZONAL"
  tier                            = var.instance_size
  disk_size                       = var.disk_size_gb
  disk_autoresize                 = var.disk_auto_resize
  disk_type                       = "PD_SSD"
  create_timeout                  = var.db_timeout
  update_timeout                  = var.db_timeout
  delete_timeout                  = var.db_timeout
  user_name                       = var.root_user_name
  user_password                   = var.root_user_password
  database_flags                  = local.db_flags
  user_labels                     = var.labels
  additional_users                = var.additional_users
  additional_databases            = var.additional_databases
  maintenance_window_day          = var.maintenance_window.day_utc
  maintenance_window_hour         = var.maintenance_window.hour_utc
  maintenance_window_update_track = var.maintenance_window.update_track
  insights_config                 = var.insights_config
  ip_configuration = {
    authorized_networks = local.authorized_networks
    ipv4_enabled        = var.public_access
    private_network     = var.private_network
    require_ssl         = null
  }

  # backup settings
  backup_configuration = {
    enabled                        = var.backup_enabled
    binary_log_enabled             = var.binary_log_enabled
    start_time                     = "00:05"
    point_in_time_recovery_enabled = var.pit_recovery_enabled
    transaction_log_retention_days = null
    retained_backups               = null
    retention_unit                 = null
  }
}

resource "google_project_iam_member" "cloudsql_proxy_user" {
  for_each   = toset(var.sql_proxy_user_groups)
  project    = data.google_client_config.google_client.project
  role       = "roles/cloudsql.client" # see https://cloud.google.com/sql/docs/sqlserver/quickstart-proxy-test#before-you-begin
  member     = "group:${each.value}"
  depends_on = [google_project_service.compute_api, google_project_service.cloudsql_api]
}
