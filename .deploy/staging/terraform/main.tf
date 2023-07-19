# MAIN

########################################
# VARIABLES DEFINITION
########################################
variable domain_name {
  type = string
}
variable staging_subdomain {
  type = string
  default = "staging"
}
variable ssh_keys {
  type = list(string)
}
variable spaces_access_id {
  type = string
}
variable spaces_secret_key {
  type = string
}
variable authorized_keys {
  type = list(string)
}
variable do_token {
  type = string
}

########################################
# PROVIDER SETUP
########################################
terraform {
  required_version = ">= 1.0.0"

  cloud {
    organization = "mighties"

    workspaces {
      name = "mighty-cats-web"
    }
  }

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
  spaces_access_id  = var.spaces_access_id
  spaces_secret_key = var.spaces_secret_key
}


########################################
# DATA (Existing resources)
########################################
data "digitalocean_ssh_key" "ssh_keys" {
  name = "${each.value}"

  for_each = toset(var.ssh_keys)
}

data "digitalocean_domain" "web" {
  name = var.domain_name
}

data "digitalocean_project" "mighty-cats" {
  name = "Mighty Cats"
}

########################################
# WEB SERVER
########################################
resource "digitalocean_droplet" "staging" {
  image     = "devdojo-laravel-20-04"
  name      = "staging"
  region    = "nyc1"
  size      = "s-1vcpu-1gb"
  ssh_keys  = [for key in data.digitalocean_ssh_key.ssh_keys: key.id]
  tags      = ["staging-webserver"]
  user_data = templatefile("staging_server.tftpl", {keys = var.authorized_keys})
}

resource "digitalocean_record" "staging-dns-record" {
  domain = data.digitalocean_domain.web.name
  type   = "A"
  name   = var.staging_subdomain
  value  = digitalocean_droplet.staging.ipv4_address
  ttl    = 180
}

resource "digitalocean_record" "staging-www-dns-record" {
  domain = data.digitalocean_domain.web.name
  type   = "A"
  name   = "www.${var.staging_subdomain}"
  value  = digitalocean_droplet.staging.ipv4_address
  ttl    = 180
}

########################################
# DATABASE
########################################
# resource "digitalocean_database_cluster" "mysql-cluster" {
#   name       = "staging-db"
#   engine     = "mysql"
#   version    = "8"
#   size       = "db-s-1vcpu-1gb"
#   region     = "nyc1"
#   node_count = 1
# }
# resource "digitalocean_database_firewall" "mysql-cluster-firewall" {
#   cluster_id = digitalocean_database_cluster.mysql-cluster.id

#   rule {
#       type = "tag"
#       value = "staging-webserver"
#   }
# }

########################################
# ASSETS CDN
########################################
resource "digitalocean_spaces_bucket" "assets-bucket" {
  name   = "staging-assets"
  region = "nyc3"
  acl    = "private"
  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["https://${var.staging_subdomain}.${var.domain_name}"]
    max_age_seconds = 600
  }
  force_destroy = true
}

resource "digitalocean_certificate" "assets-cert" {
  name    = "${var.staging_subdomain}-assets-cert"
  type    = "lets_encrypt"
  domains = ["${var.staging_subdomain}-assets.${data.digitalocean_domain.web.name}"]
}

resource "digitalocean_cdn" "assets-cdn" {
  depends_on = [
    digitalocean_spaces_bucket.assets-bucket
  ]

  origin           = digitalocean_spaces_bucket.assets-bucket.bucket_domain_name
  custom_domain    = "${var.staging_subdomain}-assets.${data.digitalocean_domain.web.name}"
  certificate_name = digitalocean_certificate.assets-cert.name
}

resource "digitalocean_project_resources" "resources" {
  depends_on = [
    digitalocean_droplet.staging,
    digitalocean_spaces_bucket.assets-bucket
  ]

  project = data.digitalocean_project.mighty-cats.id
  resources = [
    digitalocean_droplet.staging.urn,
    digitalocean_spaces_bucket.assets-bucket.urn
  ]
}

########################################
# POST DROPLET INIT
########################################
resource "null_resource" "wait" {
  depends_on = [
    digitalocean_droplet.staging
  ]

  provisioner "local-exec" {
    command = "sleep 120"
  }
}

resource "null_resource" "post_init" {
  depends_on = [
    null_resource.wait
  ]

  connection {
    host = digitalocean_droplet.staging.ipv4_address
    type = "ssh"
    user = "root"
    private_key = file("./tf_digitalocean")
  }

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait",
      "sudo chown root:web -R /var/www",
      "sudo chmod g+w /var/www",
      "rm -rf /etc/update-motd.d/99-one-click",
      "sudo sed -e '/laravel/ s/^#*/#/' -i ~/.bashrc",
      "sudo rm -rf /var/www/laravel",
      "sudo rm /etc/nginx/sites-available/laravel && sudo rm /etc/nginx/sites-enabled/laravel",
      "sudo ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/",
      "sudo service nginx restart && sudo service php8.2-fpm restart",
    ]
  }
}
