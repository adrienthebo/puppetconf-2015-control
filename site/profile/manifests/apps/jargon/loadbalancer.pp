class profile::apps::jargon::loadbalancer {
  include nginx
  nginx::resource::upstream { 'app-pool':
    members => [
      '10.20.1.8:8080',
      '10.20.1.9:8080',
      '10.20.1.10:8080',
    ],
  }

  nginx::resource::vhost { 'app.puppetconf.demo':
    proxy => 'http://app-pool',
  }
}
