module Pusher
  class App
    ASYNC_CALLBACK = "async.callback".freeze
    
    AsyncResponse = [-1, {}, []].freeze
    InvalidResponse = [500, {"Content-Type" => "text/html"}, ["Invalid request"]].freeze
    
    attr_reader :session_key, :channel_key
    
    def initialize(options={})
      @session_key = options[:session_key] || "session_id"
      @channel_key = options[:channel_key] || "channel_id"
      @channel = options[:channel] || Channel::AMQP.new
      @logger = options[:logger]
    end
    
    def call(env)
      request = Rack::Request.new(env)
      channel_id = request[@channel_key]
      session_id = request[@session_key]
      
      return InvalidResponse unless channel_id && session_id
      @logger.info "Connection on channel #{channel_id} from #{session_id}" if @logger
      
      transport = Transport::Base.select(request)
      transport.on_close { @logger.info "Connection closed on channel #{channel_id} from #{session_id}" } if @logger
      
      @channel.subscribe(channel_id, session_id, transport)
      
      EM.next_tick { env[ASYNC_CALLBACK].call transport.render }
      AsyncResponse
    end
  end
end
