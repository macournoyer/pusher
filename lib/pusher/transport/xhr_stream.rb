module Pusher
  module Transport
    class XhrStream < Base
      register :xhr_stream
      
      def content_type
        'application/x-event-stream'
      end
      
      def opened
        # Safari requires a padding of 256 bytes to render
        renderer.call [" " * 256]
      end
      
      def write(data)
        renderer.call [data]
      end
    end
  end
end