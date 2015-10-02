class role::apps::jargon::loadbalancer {
  include profile::production

  include profile::apps::jargon::loadbalancer
}
