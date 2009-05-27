Pusher.XhrStream = Class.create(Pusher.Transport, {
  connect: function() {
    var len = 0;
    var self = this;
    
    new Ajax.Request(this.url, {
      method: 'get',
      parameters: 'transport=xhr_stream',

      onInteractive: function(transport) {
        var data = transport.responseText.slice(len).strip();
        len = transport.responseText.length;
        if (!data.blank()) self.callback(data);
      },

      onComplete: function() {
        self.connect.bind(self).delay(self.RECONNECT_DELAY);
      }
    });
  }
});