class profile::monitoring::graphite {
  class { "::graphite":
    secret_key         => "hunter2",
    gr_django_pkg      => 'django',
    gr_django_ver      => '1.5',
    gr_django_provider => 'pip',
    gr_storage_schemas => [
      {
        name       => 'carbon',
        pattern    => '^carbon\.',
        retentions => '1m:90d'
      },
      {
        name       => 'diamond',
        pattern    => '^servers\.',
        retentions => '15s:6h,1m:14d',
      },
      {
        name       => 'default',
        pattern    => '.*',
        retentions => '10s:30m,1m:1d,5m:2y'
      }
    ],
    gr_storage_aggregation_rules => {
      '00_min'         => { pattern => '\.min$',   factor => '0.1', method => 'min' },
      '01_max'         => { pattern => '\.max$',   factor => '0.1', method => 'max' },
      '02_sum'         => { pattern => '\.count$', factor => '0.1', method => 'sum' },
      '99_default_avg' => { pattern => '.*',       factor => '0.1', method => 'average'}
    },
    gr_timezone => 'America/Los_Angeles',
  }
}
