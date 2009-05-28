require File.dirname(__FILE__) + "/spec_helper"

EM.describe Pusher::DeferrableBody do
  before do
    @body = Pusher::DeferrableBody.new
  end
  
  it "should not be closed" do
    @body.should_not be_closed
    done
  end

  it "should be closed on succeed" do
    @body.succeed
    @body.should be_closed
    done
  end

  it "should be closed on failed" do
    @body.fail
    @body.should be_closed
    done
  end
  
  it "should have enqueued_size" do
    @body.enqueued_size.should == 0
    @body.call ["hi"]
    @body.enqueued_size.should == 2
    done
  end
  
  it "should enqueue data" do
    @body.call ["sweet"]
    @body.call ["choco"]
    @body.queue.should == [["sweet"], ["choco"]]
    done
  end

  it "should dequeue data" do
    chunks = []
    @body.each { |chunk| chunks << chunk }
    @body.call ["sweet"]
    @body.call ["choco"]
    EM.next_tick do
      chunks.should == ["sweet", "choco"]
      done
    end
  end
end