$:.unshift File.dirname(__FILE__) + "/../lib"
require "rubygems"
require "pusher"

AMQP.start do
  Pusher::Channel.new(ARGV[0]).publish(ARGV[1])
  AMQP.stop { EM.stop }
end
