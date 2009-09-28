require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AdaptivePay::Recipient do

  before :each do
    @recipient = AdaptivePay::Recipient.new
  end

  describe "attributes" do

    %w{account amount primary}.each do |attribute|
      it "should have #{attribute} attribute" do
        @recipient.send("#{attribute}=", "test")
        @recipient.send(attribute).should == "test"
      end
    end

  end

end
