require File.dirname(__FILE__) + "/spec_helper"
require "rack/mock"

EM.describe Pusher::App do
  before do
    @app = Pusher::App.new(:session_key => "thekeytoyourheart", :channel_key => "love")
    @request = Rack::MockRequest.new(@app)
  end
  
  it "should accept options" do
    @app.session_key.should == "thekeytoyourheart"
    @app.channel_key.should == "love"
  end
  
  it "should return server error on missing parameters" do
    @request.get("/").should be_server_error
  end
  
  after do
    done
  end
end