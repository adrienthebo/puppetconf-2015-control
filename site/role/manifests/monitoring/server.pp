class role::monitoring::server {
  include profile::production

  include profile::monitoring::graphite
  include profile::monitoring::grafana
}
