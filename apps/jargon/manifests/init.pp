class jargon {

  require "unicorn"

  package { "sinatra-contrib":
    ensure   => present,
    provider => "gem",
  }

  # monitoring
  package { ["lookout-statsd", "rack-graphite"]:
    ensure   => present,
    provider => "gem",
  }

  user { "jargon":
    ensure     => present,
    home       => "/srv/jargon",
    managehome => true,
    system     => true,
  }

  file { "/srv/jargon":
    ensure  => present,
    source  => "puppet:///modules/jargon/rb",
    owner   => "jargon",
    group   => "jargon",
    recurse => true,
  }

  unicorn::app { "jargon":
    app_root => "/srv/jargon",
    user     => "jargon",
    group    => "jargon",
  }
}
