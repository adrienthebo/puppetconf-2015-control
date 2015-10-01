load './jargon-api.rb'

require 'statsd'
require 'rack/graphite'

Statsd.create_instance host: "127.0.0.1"

use Rack::Graphite, prefix: "app.jargon"

run Jargon::API
