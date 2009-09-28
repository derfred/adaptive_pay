require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AdaptivePay::PaymentPlan do

  before :each do
    @payment_plan = AdaptivePay::PaymentPlan.new
  end

  describe "initialize" do

    it "should pass self to block if given" do
      called = false
      AdaptivePay::PaymentPlan.new do |p|
        called = true
        p.should be_a(AdaptivePay::PaymentPlan)
      end
      called.should be_true
    end

  end

  describe "attributes" do

    %w{currency reverse_all_parallel_payments_on_error cancel_url return_url ipn_url}.each do |attribute|
      it "should have #{attribute} attribute" do
        @payment_plan.send("#{attribute}=", "test")
        @payment_plan.send(attribute).should == "test"
      end
    end

  end

  describe "sender" do

    it "should save sender object" do
      @payment_plan.sender = AdaptivePay::Sender.new :account => "test@paypal.com", :client_ip => "12.23.34.45"
      @payment_plan.sender.should be_a(AdaptivePay::Sender)
      @payment_plan.sender.account.should == "test@paypal.com"
      @payment_plan.sender.client_ip.should == "12.23.34.45"
    end

    it "should save sender hash" do
      @payment_plan.sender = { :account => "test@paypal.com", :client_ip => "12.23.34.45" }
      @payment_plan.sender.should be_a(AdaptivePay::Sender)
      @payment_plan.sender.account.should == "test@paypal.com"
      @payment_plan.sender.client_ip.should == "12.23.34.45"
    end

  end

  describe "add_recipient" do

    it "should add a Recipient to recipients from Recipient" do
      recipient = AdaptivePay::Recipient.new :account => "recipient@paypal.com",
                                             :amount => BigDecimal.new("10.00"),
                                             :primary => false
      @payment_plan.add_recipient recipient
      @payment_plan.recipients.size.should == 1
      @payment_plan.recipients.first.should == recipient
    end

    it "should add a Recipient to recipients from hash" do
      @payment_plan.add_recipient :account => "recipient@paypal.com",
                                  :amount => BigDecimal.new("10.00"),
                                  :primary => false
      @payment_plan.recipients.size.should == 1
      @payment_plan.recipients.first.account.should == "recipient@paypal.com"
      @payment_plan.recipients.first.amount.should == BigDecimal.new("10.00")
      @payment_plan.recipients.first.primary.should == false
    end

  end

end
