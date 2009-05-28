require File.dirname(__FILE__) + "/../spec_helper"

EM.describe Pusher::Transport::XhrStream do
  before do
    @request = mock("request")
    @transport = Pusher::Transport::XhrStream.new(@request)
  end
  
  it "should render" do
    @transport.render.should == [200, {'Content-Type' => 'application/x-event-stream'}, @transport.renderer]
    done
  end
  
  it "should pad with 256 bytes" do
    @transport.renderer.enqueued_size.should == 256
    done
  end
  
  it "should write data to renderer" do
    @transport.write "data"
    @transport.renderer.queue.last.should == ["data"]
    done
  end

  it "should keep connection opened" do
    @transport.write "data"
    EM.next_tick do
      @transport.should_not be_closed
      done
    end
  end

  it "should close connection when sending more then 1048576 bytes" do
    @transport.write "x" * 1048576
    @transport.write "!"
    EM.next_tick do
      @transport.should be_closed
      done
    end
  end
end
