Terraform module for a SQLServer CloudSQL Instance in GCP

# Upgrade guide from v2.2.0 to v2.2.1

This upgrade requires google provider [v3.44.0](https://github.com/hashicorp/terraform-provider-google/releases/tag/v3.44.0) or above which introduces the `deletion_protection` feature to `google_sql_database_instance` resources. Plan & Apply the google provider version upgrade first **before** upgrading this module version to `v2.2.1`.

# Upgrade guide from v2.1.1 to v2.2.0

First make sure you've planned & applied `v2.1.1`. Then, upon upgrading from `v2.1.1` to `v2.2.0`, you may (or may not) see a plan that destroys & creates an equal number of `google_project_iam_member` resources. It is OK to apply these changes as it will only change the data-structure of these resources [from an array to a hashmap](https://github.com/airasia/terraform-google-external_access/wiki/The-problem-of-%22shifting-all-items%22-in-an-array). Note that, after you plan & apply these changes, you may (or may not) get a **"Provider produced inconsistent result after apply"** error. Just re-plan and re-apply and that would resolve the error.
