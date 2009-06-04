# Sample Rack app using Pusher
# 1) Start an AMQP server (like RabbitMQ) on localhost
# 2) Run thin start -R example/config.ru
# 3) Browse to http://localhost:3000/ and follow instructions on the page
$:.unshift File.dirname(__FILE__) + "/../lib"
require "pusher"
require "logger"

use Rack::CommonLogger
use Rack::ShowExceptions

# This is just for development purpose, you'd normaly use the static pusher.js file
require File.dirname(__FILE__) + "/../client/sprockets"
use Rack::Sprockets, :path         => "/pusher.js",
                     :load_path    => ["client/src"],
                     :source_files => ["client/src/pusher.js"]

map "/pusher" do
  run Pusher::App.new(:channel => Pusher::Channel::AMQP.new,
                      :logger => Logger.new(STDOUT))
end

map "/" do
  run proc { |env| [200,
                    {'Content-Type' => 'text/html'},
                    [File.read(File.dirname(__FILE__) + "/index.html")]] }
end

