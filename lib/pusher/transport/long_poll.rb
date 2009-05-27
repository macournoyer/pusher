module Pusher
  module Transport
    class LongPoll < Base
      register :long_poll
      register :default
      
      def write(data)
        # Safari requires a padding of 256 bytes to render
        renderer.call [" " * 256 + data]
        EM.next_tick { renderer.succeed }
      end
    end
  end
end