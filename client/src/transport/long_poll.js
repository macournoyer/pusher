Pusher.LongPoll = Class.create(Pusher.Transport, {
  name: "long_poll",
  
  connect: function() {
    var self = this;
    
    new Ajax.Request(this.url, {
      method: 'get',
      
      onCreate: function(response) {
        // Safari does not trigger onComplete when on error
        if (Prototype.Browser.WebKit)
          response.request.transport.onerror = self.reconnect.bind(self);
      },

      onComplete: function(transport) {
        if (transport.status == 0) {
          self.reconnect();
        } else {
          var data = transport.responseText.strip();
          if (data.length > 0)
            self.callback(data);
          self.connect.bind(self).defer();
        }
      }
    });
  }
});