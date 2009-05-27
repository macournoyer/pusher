Pusher.XhrStream = Class.create(Pusher.Transport, {
  connect: function() {
    var len = 0;
    var self = this;
    
    new Ajax.Request(this.url, {
      method: 'get',
      parameters: 'transport=xhr_stream',
      
      onCreate: function(response) {
        // Safari does not trigger onComplete when an error occures while connecting
        if (Prototype.Browser.WebKit)
          response.request.transport.onerror = self.reconnect.bind(self);
      },

      onInteractive: function(transport) {
        var data = transport.responseText.slice(len).strip();
        len = transport.responseText.length;
        if (data.length > 0) self.callback(data);
      },

      onComplete: function() {
        self.reconnect()
      }
    });
  }
});