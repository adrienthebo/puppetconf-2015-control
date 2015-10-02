class role::apps::jargon::appserver {
  include profile::production

  include profile::apps::jargon::web
  include profile::monitoring::statsd
}
