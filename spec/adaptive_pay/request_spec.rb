require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AdaptivePay::Request do

  describe "initialize" do

    it "should pass self to block if given" do
      called = false
      AdaptivePay::Request.new do |p|
        called = true
        p.should be_a(AdaptivePay::Request)
      end
      called.should be_true
    end

  end

end
