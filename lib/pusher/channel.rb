module Pusher
  class Channel
    def initialize(id)
      @id = id
      @mq = MQ.new
      @topic = @mq.topic("pusher")
    end
    
    def key
      "channel.#{@id}"
    end
    
    def subscribe(session_id, transport)
      queue = @mq.queue("#{key}.#{session_id}")

      queue.bind(@topic, :key => key).subscribe do |message|
        transport.write message
      end

      # TODO maybe delay queue deletion until unused for 1 min or so
      transport.on_close { queue.delete }
    end
    
    def publish(message)
      @topic.publish(message, :routing_key => key)
    end
  end
end