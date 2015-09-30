class unicorn {

  require "buildenv::cpp"

  package { "unicorn":
    ensure   => present,
    provider => "gem",
  }
}
