require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AdaptivePay::ApprovalRequest do

  before :each do
    @request = AdaptivePay::ApprovalRequest.new
  end

  describe "attributes" do

    %w{valid_from valid_until}.each do |attribute|
      it "should have #{attribute} attribute" do
        @request.send("#{attribute}=", "test")
        @request.send(attribute).should == "test"
      end
    end

  end

end
