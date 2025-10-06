terraform {
	required_providers {
		tessell = {
			source  = "tessell-cloud/tessell"
		}
	}
}

provider "tessell" {
	api_address = "https://api.cs.tessell-stage.com"
	tenant_id = "5e325c4d-d22f-4294-812c-98e50e9a0656"
	api_key = var.api_key
}

variable "api_key" {
  type = string
  default = "" # You can leave this empty if you're using TF_VAR_api_key instead
}

resource "tessell_db_service" "TF_WF_Testing_Mysql" {
	name = "TF-WF-Testing-Mysql"
	description = ""
	subscription = "azure-byoa"
	edition = "COMMUNITY"
	engine_type = "MYSQL"
	topology = "single_instance"
	software_image = "MySQL 8.4"
	software_image_version = "MySQL 8.4.4 (RHEL)"
	auto_minor_version_update = true
	enable_deletion_protection = false
	enable_stop_protection = false
	infrastructure {
		cloud = "azure"
		region = "centralIndia"
		availability_zone = "1"
		vpc = "tessell-virtual-network-b9aa7"
		private_subnet = "tessell-private-subnet"
		compute_type = "tesl_4_b-2"
		enable_encryption = false
		encryption_key = null
		additional_storage = 0
	}
	service_connectivity {
		service_port = "3306"
		enable_public_access = false
		allowed_ip_addresses = [
			"10.0.0.0/24",
		]
		enable_ssl = false
	}
	enable_perf_insights = false
	creds {
		master_user = "master"
		master_password = "Tessell123ZX@$"
	}
	maintenance_window {
		day = "Sunday"
		time = "02:00"
		duration = 30
	}
	engine_configuration {
		mysql_config {
			parameter_profile_id = "1bfb8920-cdec-4721-a90f-0b3be314b5da"
		}
	}
	databases {
		database_name = "db1"
		database_configuration {
			mysql_config {
				parameter_profile_id = "1bfb8920-cdec-4721-a90f-0b3be314b5da"
			}
		}
	}
	rpo_policy_config {
		enable_auto_snapshot = true
		enable_auto_backup = false
		include_transaction_logs = true
		standard_policy {
			retention_days = 7
			snapshot_start_time {
				hour = 1
				minute = 0
			}
		}
	}
	instances {
		role = "primary"
		storage_config {
			provider = "AZURE_MANAGED_DISK"
		}
		private_subnet = "tessell-private-subnet"
		availability_zone = "1"
		name = "default-node-0"
		region = "centralIndia"
		instance_group_name = "default"
		vpc = "tessell-virtual-network-b9aa7"
		compute_type = "tesl_4_b-2"
	}
}
