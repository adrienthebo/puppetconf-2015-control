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
    secret_key     => "hunter2",
    gr_django_pkg      => 'django',
    gr_django_ver      => '1.5',
    gr_django_provider => 'pip',
  }
}

node /app/ {
  class { "jargon": }
}

node /lb1/ {
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

  class { "diamond":
    install_from_pip => true,
    graphite_host    => "mon1",
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
