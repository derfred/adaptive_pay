require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AdaptivePay::AbstractPaymentRequest do

  before :each do
    @payment_request = AdaptivePay::AbstractPaymentRequest.new
  end

  describe "sender" do

    it "should save sender object" do
      @payment_request.sender = AdaptivePay::Sender.new :email => "test@paypal.com", :client_ip => "12.23.34.45"
      @payment_request.sender.should be_a(AdaptivePay::Sender)
      @payment_request.sender.email.should == "test@paypal.com"
      @payment_request.sender.client_ip.should == "12.23.34.45"
    end

    it "should save sender hash" do
      @payment_request.sender = { :email => "test@paypal.com", :client_ip => "12.23.34.45" }
      @payment_request.sender.should be_a(AdaptivePay::Sender)
      @payment_request.sender.email.should == "test@paypal.com"
      @payment_request.sender.client_ip.should == "12.23.34.45"
    end

  end

  describe "serialize" do

    it "should include sender details in serialization" do
      request = AdaptivePay::AbstractPaymentRequest.new
      request.sender = { :client_ip => "11.22.33.44", :email => "sender@paypal.com" }
      decompose(request.serialize).should == {
        "clientDetails.ipAddress" => "11.22.33.44",
        "senderEmail" => "sender@paypal.com"
      }
    end

  end

end
