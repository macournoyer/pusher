require File.dirname(__FILE__) + "/../spec_helper"

EM.describe Pusher::Transport::Sse do
  before do
    @request = mock("request")
    @transport = Pusher::Transport::Sse.new(@request)
  end
  
  it "should render" do
    @transport.render.should == [200, {'Content-Type' => 'application/x-dom-event-stream'}, @transport.renderer]
    done
  end
  
  it "should write data to renderer" do
    @transport.write "muffin"
    @transport.renderer.queue.last.should == [
      "Event: message\n" +
      "data: muffin\n" +
      "\n"
    ]
    done
  end

  it "should write multiline data as seperate keys" do
    @transport.write "cranberry\nmuffin"
    @transport.renderer.queue.last.should == [
      "Event: message\n" +
      "data: cranberry\n" +
      "data: muffin\n" +
      "\n"
    ]
    done
  end
  
  it "should keep connection opened" do
    @transport.write "data"
    EM.next_tick do
      @transport.should_not be_closed
      done
    end
  end
end