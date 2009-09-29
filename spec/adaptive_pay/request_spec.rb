require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'fakeweb'

describe AdaptivePay::Request do

  before :each do
    FakeWeb.allow_net_connect = false
  end

  after :each do
    FakeWeb.allow_net_connect = true
  end

  describe "self.attribute" do

    it "should generate setter method" do
      class MyKlass1 < AdaptivePay::Request
        attribute "myAttrib"
      end

      obj = MyKlass1.new
      obj.should respond_to(:my_attrib=)
    end

    it "should generate getter method" do
      class MyKlass2 < AdaptivePay::Request
        attribute "myAttrib"
      end

      obj = MyKlass2.new
      obj.should respond_to(:my_attrib)
    end

    it "should allow setting and retrieving attribute" do
      class MyKlass3 < AdaptivePay::Request
        attribute "myAttrib"
      end

      obj = MyKlass3.new
      obj.my_attrib = "test"
      obj.my_attrib.should == "test"
    end


    it "should add attribute to list" do
      class MyKlass4 < AdaptivePay::Request
        attribute "myAttrib"
      end
      MyKlass4.attribute_names.should include("myAttrib")
    end

    it "should build inheritable attributes" do
      class ParentKlass < AdaptivePay::Request
        attribute "myInheritableAttrib"
      end
      class ChildKlass < ParentKlass
        attribute "myAttrib"
      end

      ChildKlass.attribute_names.should include("myInheritableAttrib")
      obj = ChildKlass.new
      obj.should respond_to(:my_inheritable_attrib=)
      obj.should respond_to(:my_inheritable_attrib)
    end


    it "should map nested attributes to the toplevel" do
      class MyKlass5 < AdaptivePay::Request
        attribute "myGroup.myAttrib"
      end

      MyKlass5.attribute_names.should include("myGroup.myAttrib")
      obj = MyKlass5.new
      obj.should respond_to(:my_attrib=)
      obj.should respond_to(:my_attrib)
    end

  end

  describe "initialize" do

    it "should pass self to block if given" do
      called = false
      AdaptivePay::Request.new do |p|
        called = true
        p.should be_a(AdaptivePay::Request)
      end
      called.should be_true
    end

    it "should set default attributes if present" do
      class MyKlass6 < AdaptivePay::Request
        attribute "myAttrib", :default => "value"
      end

      obj = MyKlass6.new
      obj.my_attrib.should == "value"
    end

  end

  describe "perform" do

    def mock_interface(options={})
      mock(:interface, {:base_url => "https://somewhere.at.paypal.cc", :username => "username", :password => "password", :signature => "signature"}.merge(options))
    end

    it "should send request to base_url + request specific endpoint" do
      class MyKlass8 < AdaptivePay::Request
        self.endpoint = "my_endpoint"
      end

      request = MyKlass8.new
      FakeWeb.register_uri(:post, "https://somewhere.at.paypal.cc/my_endpoint", :body => "")
      request.perform mock_interface
    end

    it "should build Response from http response" do
      class MyKlass8 < AdaptivePay::Request
        self.endpoint = "my_endpoint"
      end

      request = MyKlass8.new
      FakeWeb.register_uri(:post, "https://somewhere.at.paypal.cc/my_endpoint", :body => "{ actionType: 'PAY' }")
      AdaptivePay::Response.should_receive(:new).with { |resp| resp.body.should == "{ actionType: 'PAY' }" }
      request.perform mock_interface
    end

  end

end
