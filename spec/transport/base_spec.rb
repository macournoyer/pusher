require File.dirname(__FILE__) + "/../spec_helper"

EM.describe Pusher::Transport::Base do
  before do
    @request = mock("request")
  end
  
  it "should select xhr_stream transport" do
    Pusher::Transport.select("xhr_stream").should == Pusher::Transport::XhrStream
  end

  it "should select long_poll transport" do
    Pusher::Transport.select("long_poll").should == Pusher::Transport::LongPoll
  end

  it "should select sse transport" do
    Pusher::Transport.select("sse").should == Pusher::Transport::Sse
  end

  it "should default select to long_poll" do
    Pusher::Transport.select(nil).should == Pusher::Transport::LongPoll
  end

  it "should select unknown as long_poll" do
    Pusher::Transport.select("waaaa?!").should == Pusher::Transport::LongPoll
  end
  
  it "should add transport to opened list" do
    proc do
      Pusher::Transport.select(nil).new(@request)
    end.should change(Pusher::Transport::OPENED, :size).by(1)
  end

  it "should remove transport from opened list on close" do
    transport = Pusher::Transport.select(nil).new(@request)
    proc do
      transport.close
    end.should change(Pusher::Transport::OPENED, :size).by(-1)
  end
  
  after do
    done
  end
end