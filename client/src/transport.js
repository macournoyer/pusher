Pusher.Transport = Class.create({
  // Safari need to wait before connecting or else we get a spinner
  CONNECT_DELAY: 0.5, //sec
  RECONNECT_DELAY: 3, //sec
  
  initialize: function(url, channelId, callback) {
    this.sessionId = Math.uuid(12);
    this.channelId = channelId;

    var params = Object.toQueryString({ transport: this.name,
                                        channel_id: this.channelId,
                                        session_id: this.sessionId });
    this.url = url + (url.include('?') ? '&' : '?') + params;
    
    this.callback = callback;
    this.connect.bind(this).delay(this.CONNECT_DELAY);
  },
  
  name: null,
  
  connect: Prototype.emptyFunction,
  
  reconnect: function() {
    this.connect.bind(this).delay(this.RECONNECT_DELAY);
  }
});

//= require "transport/long_poll"
//= require "transport/xhr_stream"
//= require "transport/sse"
//= require "transport/html_file"