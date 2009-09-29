require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AdaptivePay::AbstractPaymentRequest do

  before :each do
    @payment_request = AdaptivePay::AbstractPaymentRequest.new
  end

  describe "sender" do

    it "should save sender object" do
      @payment_request.sender = AdaptivePay::Sender.new :account => "test@paypal.com", :client_ip => "12.23.34.45"
      @payment_request.sender.should be_a(AdaptivePay::Sender)
      @payment_request.sender.account.should == "test@paypal.com"
      @payment_request.sender.client_ip.should == "12.23.34.45"
    end

    it "should save sender hash" do
      @payment_request.sender = { :account => "test@paypal.com", :client_ip => "12.23.34.45" }
      @payment_request.sender.should be_a(AdaptivePay::Sender)
      @payment_request.sender.account.should == "test@paypal.com"
      @payment_request.sender.client_ip.should == "12.23.34.45"
    end

  end

  describe "add_recipient" do

    it "should add a Recipient to recipients from Recipient" do
      recipient = AdaptivePay::Recipient.new :account => "recipient@paypal.com",
                                             :amount => BigDecimal.new("10.00"),
                                             :primary => false
      @payment_request.add_recipient recipient
      @payment_request.recipients.size.should == 1
      @payment_request.recipients.first.should == recipient
    end

    it "should add a Recipient to recipients from hash" do
      @payment_request.add_recipient :account => "recipient@paypal.com",
                                     :amount => BigDecimal.new("10.00"),
                                     :primary => false
      @payment_request.recipients.size.should == 1
      @payment_request.recipients.first.account.should == "recipient@paypal.com"
      @payment_request.recipients.first.amount.should == BigDecimal.new("10.00")
      @payment_request.recipients.first.primary.should == false
    end

  end

end
