require File.dirname(__FILE__) + "/../spec_helper"

EM.describe Pusher::Transport::Base do
  it "should select xhr_stream transport" do
    Pusher::Transport::Base.select("xhr_stream").should == Pusher::Transport::XhrStream
  end

  it "should select long_poll transport" do
    Pusher::Transport::Base.select("long_poll").should == Pusher::Transport::LongPoll
  end

  it "should select sse transport" do
    Pusher::Transport::Base.select("sse").should == Pusher::Transport::Sse
  end

  it "should default select to long_poll" do
    Pusher::Transport::Base.select(nil).should == Pusher::Transport::LongPoll
  end

  it "should select unknown as long_poll" do
    Pusher::Transport::Base.select("waaaa?!").should == Pusher::Transport::LongPoll
  end
  
  after do
    done
  end
end