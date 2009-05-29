module Pusher
  class App
    ASYNC_CALLBACK = "async.callback".freeze
    
    AsyncResponse = [-1, {}, []].freeze
    InvalidResponse = [500, {"Content-Type" => "text/html"}, ["Invalid request"]].freeze
    
    attr_reader :session_key, :channel_key, :channel, :logger, :ping_interval
    
    def initialize(options={})
      @session_key = options[:session_key] || "session_id"
      @channel_key = options[:channel_key] || "channel_id"
      @channel = options[:channel] || Channel::AMQP.new
      @logger = options[:logger]
      @ping_interval = options[:ping_interval] || 5
      @started = false
    end
    
    def call(env)
      on_start unless @started
      
      request = Rack::Request.new(env)
      channel_id = request[@channel_key]
      session_id = request[@session_key]
      
      return InvalidResponse unless channel_id && session_id
      @logger.info "Connection on channel #{channel_id} from #{session_id}" if @logger
      
      transport = Transport.select(request["transport"]).new(request)
      transport.on_close { @logger.info "Connection closed on channel #{channel_id} from #{session_id}" } if @logger
      
      @channel.subscribe(channel_id, session_id, transport)
      
      EM.next_tick { env[ASYNC_CALLBACK].call transport.render }
      AsyncResponse
    end
    
    private
      def on_start
        EM.add_periodic_timer(@ping_interval) { Transport.ping_all }
        @started = true
      end
  end
end
