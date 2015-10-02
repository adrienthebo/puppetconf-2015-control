class profile::monitoring::grafana {
  class { "::grafana":
    install_method => "repo",
    cfg => {
      "app_mode" => 'production',
      "server"   => {
        "http_port"     => 3000,
      },
      database   => {
        "type"     => 'sqlite3',
        "host"     => '127.0.0.1:3306',
        "name"     => 'grafana',
        "user"     => 'root',
        "password" => '',
        "path"     => "grafana.db",
      },
      "users"    => {
        "allow_sign_up" => false,
      },
    }
  }
}
