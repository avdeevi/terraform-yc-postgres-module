data "yandex_resourcemanager_folder" "my_folder" {
  name =  var.env
}

data "yandex_vpc_subnet" "my_subnet_a" {
  name = "${var.env}-private-subnet${var.subnet_index}-a"
  folder_id = data.yandex_resourcemanager_folder.my_folder.id
}

data "yandex_vpc_subnet" "my_subnet_b" {
  name = "${var.env}-private-subnet${var.subnet_index}-b"
  folder_id = data.yandex_resourcemanager_folder.my_folder.id
}

data "yandex_vpc_subnet" "my_subnet_c" {
  name = "${var.env}-private-subnet${var.subnet_index}-c"
  folder_id = data.yandex_resourcemanager_folder.my_folder.id
}

locals{
subnets = [
        data.yandex_vpc_subnet.my_subnet_a,
        data.yandex_vpc_subnet.my_subnet_b,
        data.yandex_vpc_subnet.my_subnet_c
          ]
}

resource "yandex_mdb_postgresql_cluster" "pg_cluster" {
  name        = var.name
  environment = var.type
  network_id  = var.network_id
  folder_id   = var.folder_id

  config {
    version = var.pg_version
    autofailover = var.autofailover
    backup_window_start {
         hours = var.backup_hour
         minutes = var.backup_minutes
    }

    pooler_config {
#       pool_discard = var.pool_discard
       pooling_mode = var.pooling_mode
    }

    resources {
      resource_preset_id = var.resource_preset
      disk_type_id       = "network-ssd"
      disk_size          = var.disk_size
    }
  }

  dynamic "database" {
    for_each = var.databases
    content {
    name  = database.value.db
    owner = database.value.user
    lc_collate = database.value.lc_collate
    lc_type = database.value.lc_type
    dynamic "extension" {
       for_each = database.value.extensions
       content {
         name = extension.value.name
         version =  extension.value.version
       }
    }
   }
  }


  dynamic "user" {
  for_each =  var.users
  content {
       name = user.value.name
       password = user.value.pass
       dynamic "permission" {
       for_each = user.value.db
       content {
          database_name = permission.value
       }
     }
   }
  }


  dynamic "user" {
  for_each = var.databases
  content {
    name     = user.value.user
    password = user.value.pass
    permission {
      database_name = user.value.db
      }
    }
  }

  dynamic "host" {
    for_each = slice(local.subnets,0,var.node_num)

  content {
    zone      = host.value.zone
    subnet_id = host.value.id
    assign_public_ip = false
    }
 }
}

