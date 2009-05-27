Pusher.Transport = Class.create({
  // Safari need to wait before connecting or else we get a spinner
  CONNECT_DELAY: 0.5, //sec
  RECONNECT_DELAY: 3, //sec
  
  initialize: function(url, callback) {
    this.url = url;
    this.callback = callback;
    this.connect.bind(this).delay(this.CONNECT_DELAY);
  },
  
  connect: Prototype.emptyFunction,
  
  reconnect: function() {
    this.connect.bind(this).delay(this.RECONNECT_DELAY);
  }
});

//= require "transport/long_poll"
//= require "transport/xhr_stream"
//= require "transport/sse"
//= require "transport/html_file"