module Pusher
  # Based on version from James Tucker <raggi@rubyforge.org>
  class DeferrableBody
    include EM::Deferrable
  
    attr_reader :queue
  
    def initialize
      @queue = []
    end
  
    def closed?
      !!@deferred_status
    end
  
    def call(body)
      @queue << body
      schedule_dequeue
    end

    def each(&blk)
      @body_callback = blk
      schedule_dequeue
    end
  
    def enqueued_size
      @queue.flatten.join.size
    end
  
    private
      def schedule_dequeue
        return unless @body_callback
        EM.next_tick do
          next unless body = @queue.shift
          body.each do |chunk|
            @body_callback.call(chunk)
          end
          schedule_dequeue unless @queue.empty?
        end
      end
  end
end