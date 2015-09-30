define unicorn::app(
  $app_root,
  $user,
  $group,
  $port = 8080,
  $config_template = "unicorn/unicorn_config.erb",
) {

  require "unicorn"

  file { "${app_root}/unicorn_config.rb":
    ensure  => present,
    content => template($config_template),
    owner   => $user,
    group   => $group,
    mode    => "0600",
  }

  file { ["${app_root}/log", "${app_root}/tmp"]:
    ensure  => directory,
    owner   => $user,
    group   => $group,
    mode    => "0700",
  }
}
