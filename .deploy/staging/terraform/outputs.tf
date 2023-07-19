# OUTPUTS

output "ip_address" {
  value = digitalocean_droplet.staging.ipv4_address
}

# output "db_host" {
#   value = digitalocean_database_cluster.mysql-cluster.private_host
#   sensitive = true
# }
# output "db_port" {
#   value = digitalocean_database_cluster.mysql-cluster.port
# }
# output "db_database" {
#   value = digitalocean_database_cluster.mysql-cluster.database
# }
# output "db_username" {
#   value = digitalocean_database_cluster.mysql-cluster.user
# }
# output "db_password" {
#   value = digitalocean_database_cluster.mysql-cluster.password
#   sensitive = true
# }

output "assets_bucket_name" {
  value = digitalocean_spaces_bucket.assets-bucket.name
}

output "cdn_endpoint" {
  value = digitalocean_cdn.assets-cdn.custom_domain
}
