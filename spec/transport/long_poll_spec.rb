require File.dirname(__FILE__) + "/../spec_helper"

EM.describe Pusher::Transport::LongPoll do
  before do
    @request = mock("request")
    @transport = Pusher::Transport::LongPoll.new(@request)
  end
  
  it "should render" do
    @transport.render.should == [200, {'Content-Type' => 'text/html'}, @transport.renderer]
    done
  end
  
  it "should pad writes with 256 bytes" do
    @transport.write "hi"
    @transport.renderer.enqueued_size.should == 256 + 2
    done
  end
  
  it "should close connection after write" do
    @transport.write "data"
    EM.next_tick do
      @transport.should be_closed
      done
    end
  end
end