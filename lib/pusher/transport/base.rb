require "pusher/deferrable_body"

module Pusher
  module Transport
    class Base
      attr_reader :request, :renderer
      
      def initialize(request)
        @request = request
        @renderer = DeferrableBody.new
        opened
      end
      
      def content_type
        'text/html'
      end
      
      def render
        [200, {'Content-Type' => content_type}, @renderer]
      end
      
      def opened
      end

      def on_close(&block)
        renderer.callback(&block)
        renderer.errback(&block)
      end
      
      Backends = {}
      
      def self.register(name)
        Backends[name.to_s] = self
      end
      
      def self.select(request)
        (Backends[request["transport"]] || Backends["default"]).new(request)
      end
    end
  end
end