var Pusher = {
  Version: '1.0'
};

//= require "transport"

// Select transport depending on browser
if (Prototype.Browser.WebKit || Prototype.Browser.Gecko) {
  Pusher.Client = Pusher.XhrStream;
} else if (Prototype.Browser.Opera) {
  Pusher.Client = Pusher.SSE;
} else if (Prototype.Browser.IE) {
  Pusher.Client = Pusher.HtmlFile;
} else {
  Pusher.Client = Pusher.LongPoll;
}

