Pusher.LongPoll = Class.create(Pusher.Transport, {
  connect: function() {
    var self = this;
    
    new Ajax.Request(this.url, {
      method: 'get',
      parameters: 'transport=long_poll',

      onComplete: function(transport) {
        if (transport.status == 0) {
          self.connect.bind(self).delay(self.RECONNECT_DELAY);
        } else {
          self.callback(transport.responseText.strip());
          self.connect.bind(self).defer();
        }
      }
    });
  }
});