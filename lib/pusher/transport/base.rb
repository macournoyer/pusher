require "pusher/deferrable_body"

module Pusher
  module Transport
    OPENED = []
    BACKENDS = {}
    
    def self.select(transport)
      BACKENDS[transport] || BACKENDS["default"]
    end
    
    def self.ping_all
      OPENED.each { |transport| transport.renderer.call [" "] }
    end
    
    class Base
      attr_reader :request, :renderer
      
      def initialize(request)
        @request = request
        @renderer = DeferrableBody.new
        opened
        OPENED << self
        on_close { OPENED.delete(self) }
      end
      
      def content_type
        'text/html'
      end
      
      def render
        [200, {'Content-Type' => content_type}, @renderer]
      end
      
      def opened
      end
      
      def close
        renderer.succeed
      end

      def on_close(&block)
        renderer.callback(&block)
        renderer.errback(&block)
      end
      
      def closed?
        renderer.closed?
      end
      
      def self.register(name)
        BACKENDS[name.to_s] = self
      end
    end
  end
end