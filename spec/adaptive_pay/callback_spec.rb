require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AdaptivePay::Callback do

  it "should parse params" do
    callback = AdaptivePay::Callback.new "txn_id" => "3XC103945N720211C", "invoice" => "923204115", "payment_status" => "Completed"
    callback.txn_id.should == "3XC103945N720211C"
    callback.invoice.should == "923204115"
    callback.payment_status.should == "Completed"
  end

  it "should identify Completed callback" do
    callback = AdaptivePay::Callback.new "payment_status" => "Completed"
    callback.should be_completed
  end

end
