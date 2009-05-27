# Run w/ thin start -R example/simple.ru
$:.unshift File.dirname(__FILE__) + "/../lib"
require "pusher"
require File.dirname(__FILE__) + "/../client/sprockets"

use Rack::CommonLogger
use Rack::ShowExceptions

# This is just for development purpose, you'd normaly simply include the pusher.js file
use Rack::Sprockets, :path         => "/pusher.js",
                     :load_path    => ["client/src"],
                     :source_files => ["client/src/pusher.js"]

first = true
map "/pusher" do
  run Pusher::App.new
end

map "/" do
  run proc { |env| [200,
                    {'Content-Type' => 'text/html'},
                    [File.read(File.dirname(__FILE__) + "/simple.html")]] }
end

