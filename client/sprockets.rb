# Rack middleware to concatenate and serve sprocket files
# Usage:
#
#   use Rack::Sprockets, :path         => "/all.js", # URL to serve
#                        :load_path    => ["src"],   # Sprockets Secretary options
#                        :source_files => ["src/my_lib.js"]
#
require "sprockets"

module Rack
  class Sprockets
    def initialize(app, options={})
      @app = app
      @options = options
      @path = options.delete(:path) || "/sprocket.js"
    end
    
    def call(env)
      if env["PATH_INFO"] == @path
        concatenation = ::Sprockets::Secretary.new(@options).concatenation.to_s
        [200, {"Content-Type" => "text/javascript", "Content-Length" => concatenation.size.to_s}, [concatenation]]
      else
        @app.call(env)
      end
    end
  end
end
