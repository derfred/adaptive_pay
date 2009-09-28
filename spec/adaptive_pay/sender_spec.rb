require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AdaptivePay::Sender do

  before :each do
    @sender = AdaptivePay::Sender.new
  end

  describe "attributes" do

    %w{account client_ip}.each do |attribute|
      it "should have #{attribute} attribute" do
        @sender.send("#{attribute}=", "test")
        @sender.send(attribute).should == "test"
      end
    end

  end

end
