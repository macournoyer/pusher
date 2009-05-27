Pusher.Transport = Class.create({
  RECONNECT_DELAY: 3, //sec
  
  initialize: function(url, callback) {
    this.url = url;
    this.callback = callback;
    this.connect();
  },
  
  connect: Prototype.emptyFunction
});

//= require "transport/long_poll"
//= require "transport/xhr_stream"
//= require "transport/sse"
//= require "transport/html_file"