module Pusher
  module Transport
    class XhrStream < Base
      MAX_BYTES_SENT = 1048576 # Magic number taken from Orbited
      
      register :xhr_stream
      
      def content_type
        'application/x-event-stream'
      end
      
      def opened
        # Safari requires a padding of 256 bytes to render
        @sent = 256
        renderer.call [" " * 256]
      end
      
      def write(data)
        @sent += data.size
        renderer.call [data]
        EM.next_tick { renderer.succeed } if @sent > MAX_BYTES_SENT
      end
    end
  end
end