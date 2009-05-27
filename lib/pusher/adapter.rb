module Pusher
  class Adapter
    ASYNC_CALLBACK = "async.callback".freeze
    
    AsyncResponse = [-1, {}, []].freeze
    InvalidResponse = [500, {"Content-Type" => "text/html"}, ["Invalid request"]].freeze
    
    def initialize(options={})
      @session_key = options[:session_key] || "session_id"
      @channel_key = options[:channel_key] || "channel_id"
    end
    
    def call(env)
      request = Rack::Request.new(env)
      channel_id = request[@channel_key]
      session_id = request[@session_key]
      
      return InvalidResponse unless channel_id && session_id
      
      transport = Transport::Base.select(request)
      channel = Channel.new(channel_id)
      channel.subscribe(session_id, transport)
      
      EM.next_tick { env[ASYNC_CALLBACK].call transport.render }
      AsyncResponse
    end
  end
end
