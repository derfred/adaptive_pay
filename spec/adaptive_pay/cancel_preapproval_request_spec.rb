require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AdaptivePay::CancelPreapprovalRequest do

  before :each do
    @refund_request = AdaptivePay::CancelPreapprovalRequest.new
  end

  describe "serialize" do

    it "should include recipient details in serialization" do
      request = AdaptivePay::CancelPreapprovalRequest.new
      request.preapproval_key = "PA-12345"
      decompose(request.serialize).should == {
        "preapprovalKey" => "PA-12345",
        "requestEnvelope.errorLanguage" => "en_US"
      }
    end

  end

end
