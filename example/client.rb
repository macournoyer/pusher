# Client script to push messages to the browser
$:.unshift File.dirname(__FILE__) + "/../lib"
require "rubygems"
require "pusher"
require "amqp"

abort "usage: ruby client.rb <channel_id> <message>" unless ARGV.size == 2

AMQP.start do
  Pusher::Channel::AMQP.new.publish(ARGV[0], ARGV[1])
  AMQP.stop { EM.stop }
end
