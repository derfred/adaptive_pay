require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AdaptivePay::RefundRequest do

  before :each do
    @refund_request = AdaptivePay::RefundRequest.new
  end

  describe "serialize" do

    it "should include recipient details in serialization" do
      request = AdaptivePay::RefundRequest.new
      request.add_recipient :email => "acc@paypal.com", :amount => 100
      request.add_recipient :email => "primary@paypal.com", :amount => 10, :primary => true
      decompose(request.serialize).should == {
        "receiverList.receiver(0).email" => "acc@paypal.com",
        "receiverList.receiver(0).amount" => "100.00",
        "receiverList.receiver(0).primary" => "false",
        "receiverList.receiver(1).email" => "primary@paypal.com",
        "receiverList.receiver(1).amount" => "10.00",
        "receiverList.receiver(1).primary" => "true",
        "requestEnvelope.errorLanguage" => "en_US"
      }
    end

  end

  describe "add_recipient" do

    it "should add a Recipient to recipients from Recipient" do
      recipient = AdaptivePay::Recipient.new :email => "recipient@paypal.com",
                                             :amount => BigDecimal.new("10.00"),
                                             :primary => false
      @refund_request.add_recipient recipient
      @refund_request.recipients.size.should == 1
      @refund_request.recipients.first.should == recipient
    end

    it "should add a Recipient to recipients from hash" do
      @refund_request.add_recipient :email => "recipient@paypal.com",
                                    :amount => BigDecimal.new("10.00"),
                                    :primary => false
      @refund_request.recipients.size.should == 1
      @refund_request.recipients.first.email.should == "recipient@paypal.com"
      @refund_request.recipients.first.amount.should == BigDecimal.new("10.00")
      @refund_request.recipients.first.primary.should == false
    end

  end

end
