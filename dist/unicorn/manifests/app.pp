define unicorn::app(
  $app_root,
  $user,
  $group,
  $port = 8080,
  $config_template = "unicorn/unicorn_config.erb",
) {

  require "unicorn"

  $unicorn_config =  "${app_root}/unicorn_config.rb"

  file { $unicorn_config:
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

  file { "/etc/init/unicorn_${name}.conf":
    ensure  => present,
    content => template("unicorn/unicorn-upstart.erb"),
    owner   => "root",
    group   => "root",
    mode    => "0644",
    notify  => Exec["unicorn service ${name}: refresh upstart"],
  }

  exec { "unicorn service ${name}: refresh upstart":
    command     => "/sbin/initctl reload-configuration",
    refreshonly => true,
    notify      => Service["unicorn_${name}"],
  }

  service { "unicorn_${name}":
    ensure   => running,
    provider => "upstart",
    enable   => true,
  }
}
