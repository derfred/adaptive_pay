require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AdaptivePay::Interface do

  before :each do
    AdaptivePay::Interface.requests.clear
    @interface = AdaptivePay::Interface.new false
    @interface.base_url = "https://paypal.yumshare.com/"
  end

  describe "initialize" do

    it "should load configuration from adaptive_pay.yml according to" do
      Rails.stub!(:root).and_return(File.expand_path(File.dirname(__FILE__) + '/../fixtures'))
      Rails.stub!(:env).and_return("development")
      interface = AdaptivePay::Interface.new
      interface.environment.should == :sandbox
      interface.base_url.should == "https://svcs.sandbox.paypal.com/AdaptivePayments/"
      interface.username.should == "my_username"
      interface.password.should == "my_password"
      interface.signature.should == "my_signature"
      interface.application_id.should == "my_application_id"
      interface.should_not be_retain_requests_for_test
    end

    it "should allow setting environment as a parameter" do
      Rails.stub!(:root).and_return(File.expand_path(File.dirname(__FILE__) + '/../fixtures'))
      Rails.stub!(:env).and_return("development")
      interface = AdaptivePay::Interface.new :production
      interface.environment.should == :production
      interface.base_url.should == "https://svcs.paypal.com/AdaptivePayments/"
      interface.username.should == "my_production_username"
      interface.password.should == "my_production_password"
      interface.signature.should == "my_production_signature"
      interface.should_not be_retain_requests_for_test
    end

    it "should allow preventing the configuration loading" do
      interface = AdaptivePay::Interface.new false
      interface.environment.should be_blank
      interface.base_url.should be_blank
      interface.username.should be_blank
      interface.password.should be_blank
      interface.signature.should be_blank
    end

  end

  describe "set_environment" do

    it "should set production environment" do
      @interface.set_environment :production
      @interface.environment.should == :production
      @interface.base_url.should == "https://svcs.paypal.com/AdaptivePayments/"
    end

    it "should set sandbox environment" do
      @interface.set_environment :sandbox
      @interface.environment.should == :sandbox
      @interface.base_url.should == "https://svcs.sandbox.paypal.com/AdaptivePayments/"
    end

    it "should set beta_sandbox environment" do
      @interface.set_environment :beta_sandbox
      @interface.environment.should == :beta_sandbox
      @interface.base_url.should == "https://svcs.beta-sandbox.paypal.com/AdaptivePayments/"
    end

  end

  describe "request_preapproval" do

    before :each do
      @interface.retain_requests_for_test = true
    end

    it "should enqueue request if retain_requests_for_test is set" do
      request = AdaptivePay::PreapprovalRequest.new
      @interface.request_preapproval request
      AdaptivePay::Interface.requests.size.should == 1
      AdaptivePay::Interface.requests.first.should == request
    end

    it "should allow providing pre canned responses" do
      response = mock(:response)
      AdaptivePay::Interface.test_response = response
      @interface.request_preapproval(AdaptivePay::PreapprovalRequest.new).should == response
    end

    it "should use passed block to build request" do
      called = false
      @interface.request_preapproval do |p|
        called = true
        p.should be_a(AdaptivePay::PreapprovalRequest)
      end
      called.should be_true
    end

  end

  describe "request_payment" do

    before :each do
      @interface.retain_requests_for_test = true
    end

    it "should enqueue request if retain_requests_for_test is set" do
      request = AdaptivePay::PaymentRequest.new
      @interface.request_payment request
      AdaptivePay::Interface.requests.size.should == 1
      AdaptivePay::Interface.requests.first.should == request
    end

    it "should allow providing pre canned responses" do
      response = mock(:response)
      AdaptivePay::Interface.test_response = response
      @interface.request_payment(AdaptivePay::PaymentRequest.new).should == response
    end

    it "should use passed block to build request" do
      called = false
      @interface.request_payment do |p|
        called = true
        p.should be_a(AdaptivePay::PaymentRequest)
      end
      called.should be_true
    end

  end

  describe "request_refund" do

    before :each do
      @interface.retain_requests_for_test = true
    end

    it "should enqueue request if retain_requests_for_test is set" do
      request = AdaptivePay::RefundRequest.new
      @interface.request_refund request
      AdaptivePay::Interface.requests.size.should == 1
      AdaptivePay::Interface.requests.first.should == request
    end

    it "should allow providing pre canned responses" do
      response = mock(:response)
      AdaptivePay::Interface.test_response = response
      @interface.request_refund(AdaptivePay::RefundRequest.new).should == response
    end

    it "should use passed block to build request" do
      called = false
      @interface.request_refund do |p|
        called = true
        p.should be_a(AdaptivePay::RefundRequest)
      end
      called.should be_true
    end

  end

end
