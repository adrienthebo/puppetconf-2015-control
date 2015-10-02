## site.pp ##

# This file (/etc/puppetlabs/puppet/manifests/site.pp) is the main entry point
# used when an agent connects to a master and asks for an updated configuration.
#
# Global objects like filebuckets and resource defaults should go in this file,
# as should the default node definition. (The default node can be omitted
# if you use the console and don't define any other nodes in site.pp. See
# http://docs.puppetlabs.com/guides/language_guide.html#nodes for more on
# node definitions.)

## Active Configurations ##

# PRIMARY FILEBUCKET
# This configures puppet agent and puppet inspect to back up file contents when
# they run. The Puppet Enterprise console needs this to display file contents
# and differences.

# Define filebucket 'main':
filebucket { 'main':
  server => 'master',
  path   => false,
}

# Make filebucket 'main' the default backup location for all File resources:
File { backup => 'main' }

# DEFAULT NODE
# Node definitions in this file are merged with node data from the console. See
# http://docs.puppetlabs.com/guides/language_guide.html#nodes for more on
# node definitions.

# The default node definition matches any node lacking a more specific node
# definition. If there are no other nodes in this file, classes declared here
# will be included in every node's catalog, *in addition* to any classes
# specified in the console for that node.

node default {
  # This is where you can declare classes for all nodes.
  # Example:
  #   class { 'my_class': }
}

node /mon1/ {
  class { "graphite":
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

  class { "grafana":
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

node /app/ {
  include profile::apps::jargon::web
  include profile::monitoring
  include profile::monitoring::statsd
}

node /lb1/ {
  include profile::apps::jargon::loadbalancer
  include profile::monitoring

  # todo pip pyyaml
  diamond::collector { "PuppetAgentCollector":
    options       => {
      'yaml_path' => '/opt/puppetlabs/puppet/cache/state/last_run_summary.yaml'
    }
  }
}
