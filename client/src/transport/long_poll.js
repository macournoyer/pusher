Pusher.LongPoll = Class.create(Pusher.Transport, {
  connect: function() {
    var self = this;
    
    new Ajax.Request(this.url, {
      method: 'get',
      parameters: 'transport=long_poll',
      
      onCreate: function(response) {
        // Safari does not trigger onComplete when on error
        if (Prototype.Browser.WebKit)
          response.request.transport.onerror = self.reconnect.bind(self);
      },

      onComplete: function(transport) {
        if (transport.status == 0) {
          self.reconnect();
        } else {
          self.callback(transport.responseText.strip());
          self.connect.bind(self).defer();
        }
      }
    });
  }
});