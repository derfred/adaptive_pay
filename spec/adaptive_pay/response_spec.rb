require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AdaptivePay::Response do

  it "should parse a successful response" do
    body = "responseEnvelope.timestamp=2009-07-13T12%3A34%3A29.316-07%3A00&responseEnvelope.ack=Success&responseEnvelope.correlationId=d615a365bed61&responseEnvelope.build=DEV&payKey=AP-3TY011106S4428730&paymentExecStatus=CREATED"
    response = AdaptivePay::Response.new :other, mock(:response, :body => body, :code => "200")
    response.should be_success
    response.read_attribute("responseEnvelope.timestamp").should == "2009-07-13T12:34:29.316-07:00"
    response.read_attribute("responseEnvelope.ack").should == "Success"
    response.read_attribute("responseEnvelope.correlationId").should == "d615a365bed61"
    response.read_attribute("responseEnvelope.build").should == "DEV"
    response.pay_key.should == "AP-3TY011106S4428730"
    response.payment_exec_status.should == "CREATED"
  end

  it "should interpret a completed response as successful" do
    body = "responseEnvelope.ack=Success"
    response = AdaptivePay::Response.new :other, mock(:response, :body => body, :code => "200")
    response.should be_success
  end

  it "should interpret a http error as a non succesful response" do
    response = AdaptivePay::Response.new :other, mock(:response, :body => "", :code => "500")
    response.should_not be_success
  end

  it "should interpret a paypal error as a non succesful response" do
    body = "responseEnvelope.ack=Failure"
    response = AdaptivePay::Response.new :other, mock(:response, :body => body, :code => "200")
    response.should_not be_success
  end

  it "should build a payment_page_url for approval" do
    body = "responseEnvelope.ack=Success&preapprovalKey=PA-3TY011106S4428730"
    response = AdaptivePay::Response.new :approval, mock(:response, :body => body, :code => "200")
    response.payment_page_url.should == "https://www.paypal.com/webscr?cmd=_ap-preapproval&preapprovalkey=PA-3TY011106S4428730"
  end

  it "should build a payment_page_url for payment" do
    body = "responseEnvelope.ack=Success&payKey=AP-3TY011106S4428730"
    response = AdaptivePay::Response.new :payment, mock(:response, :body => body, :code => "200")
    response.payment_page_url.should == "https://www.paypal.com/webscr?cmd=_ap-payment&paykey=AP-3TY011106S4428730"
  end

end
