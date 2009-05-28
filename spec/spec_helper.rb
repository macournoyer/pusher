require 'rubygems'
require 'spec'

$:.unshift File.dirname(__FILE__) + "/../lib"
require "pusher"

# Try installing em-spec from http://github.com/macournoyer/em-spec
# if this doesn't work
require 'em/spec'
require 'em/spec/rspec'
EM.spec_backend = EM::Spec::Rspec

module Helpers
end

Spec::Runner.configure do |config|
  config.include Helpers
end