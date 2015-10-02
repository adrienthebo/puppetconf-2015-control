class role::apps::jargon::appserver {
  include profile::apps::jargon::web
  include profile::monitoring::statsd
}
