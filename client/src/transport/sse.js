Pusher.SSE = Class.create(Pusher.Transport, {
  connect: function() {
    var tag = document.createElement('event-source');
    tag.setAttribute("src", this.url + "&transport=sse");
    
    // Opera 9.5+ makes two connections
    if (opera.version() < 9.5) {
      document.body.appendChild(tag);
    }
    
    var self = this;
    $(tag).observe("message", function(e) {
      var data = e.data.strip();
      if (data.length > 0)
        self.callback(data);
    })
  }
});
