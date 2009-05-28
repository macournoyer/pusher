require File.dirname(__FILE__) + "/spec_helper"
require "rack/mock"

EM.describe Pusher::App do
  before do
    @channel = Pusher::Channel::InMemory.new
    @app = Pusher::App.new(:session_key => "s",
                           :channel_key => "c",
                           :channel => @channel)
    @request = Rack::MockRequest.new(@app)
  end
  
  it "should accept options" do
    @app.session_key.should == "s"
    @app.channel_key.should == "c"
    done
  end
  
  it "should return server error on missing parameters" do
    @request.get("/").should be_server_error
    done
  end
  
  it "should get async response" do
    async_response = nil
    response = @request.get("/?s=1&c=1", "async.callback" => proc { |data| async_response = data })

    response.status.should == -1
    EM.next_tick do
      async_response.first.should == 200
      done
    end
  end
end