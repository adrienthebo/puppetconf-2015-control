class profile::monitoring::diamond {

  class { "diamond":
    install_from_pip => true,
    graphite_host    => "mon1",
    interval         => 10,
    logger_level     => "DEBUG",
  }

  $collectors = [
    "CPUCollector",
    "DiskSpaceCollector",
    "DiskUsageCollector",
    "LoadAverageCollector",
    "MemoryCollector",
    "NetworkCollector",
    "TCPCollector",
  ]

  diamond::collector { $collectors: }
}
