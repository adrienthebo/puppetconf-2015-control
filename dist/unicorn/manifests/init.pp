class unicorn {

  require "ruby::dev"

  package { "unicorn":
    ensure   => present,
    provider => "gem",
  }
}
