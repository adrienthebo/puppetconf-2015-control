class profile::monitoring::statsd {
  class { "nodejs": } ->
  class { 'statsd':
    backends         => [ './backends/graphite'],
    graphiteHost     => 'mon1.puppetconf.demo',
    flushInterval    => 1000,
    percentThreshold => [75, 90, 99],
  }
}
