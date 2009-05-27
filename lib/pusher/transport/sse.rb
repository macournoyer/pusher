module Pusher
  module Transport
    class Sse < Base
      register :sse
      
      def content_type
        "application/x-dom-event-stream"
      end
      
      def write(data)
        renderer.call ["Event: message\n" +
                       data.split("\n").map { |datum| "data: #{datum}\n" }.join +
                       "\n"]
      end
    end
  end
end