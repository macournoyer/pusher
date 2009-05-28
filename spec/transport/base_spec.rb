require File.dirname(__FILE__) + "/../spec_helper"

EM.describe Pusher::Transport::Base do
  it "should select xhr_stream transport" do
    Pusher::Transport::Base.select("transport" => "xhr_stream").should be_instance_of(Pusher::Transport::XhrStream)
  end

  it "should select long_poll transport" do
    Pusher::Transport::Base.select("transport" => "long_poll").should be_instance_of(Pusher::Transport::LongPoll)
  end

  it "should select sse transport" do
    Pusher::Transport::Base.select("transport" => "sse").should be_instance_of(Pusher::Transport::Sse)
  end

  it "should default select to long_poll" do
    Pusher::Transport::Base.select({}).should be_instance_of(Pusher::Transport::LongPoll)
  end

  it "should select unknown as long_poll" do
    Pusher::Transport::Base.select("transport" => "waaaa?!").should be_instance_of(Pusher::Transport::LongPoll)
  end
  
  after do
    done
  end
end