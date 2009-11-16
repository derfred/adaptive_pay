require "erb"

module AdaptivePay
  class Interface

    def self.requests
      @requests ||= []
    end

    cattr_accessor :test_response
    attr_accessor :test_response

    attr_accessor :base_url, :base_page_url, :environment, :username, :password, :signature, :application_id, :retain_requests_for_test

    def self.test_interface(response = nil)
      iface = new false
      iface.retain_requests_for_test = true
      iface.test_response = response
      iface
    end

    # Initialize a new interface object, takes an optional rails_env parameter
    # 
    # The rails_env parameter decides which configuration to load can be:
    #   nil -> use current Rails.env section in config/adaptive_pay.yml
    #   false -> dont load config from config/adaptive_pay.yml
    #   string/symbol -> use that section from config/adaptive_pay.yml
    def initialize(rails_env=nil)
      load(rails_env||Rails.env) unless rails_env == false
    end

    def load(rails_env)
      config = YAML.load(ERB.new(File.read(File.join(Rails.root, "config/adaptive_pay.yml"))).result)[rails_env.to_s]
      if config["retain_requests_for_test"] == true
        @retain_requests_for_test = true
      else
        set_environment config.delete("environment")
        config.each do |k, v|
          send "#{k}=", v
        end
      end
    end

    # Explicitly select a paypal environment to connect to
    # environment parameter can be :production, :sandbox, :beta_sandbox
    def set_environment(environment)
      @environment = environment.to_sym
      @base_url = {
        :production => "https://svcs.paypal.com/AdaptivePayments/",
        :sandbox => "https://svcs.sandbox.paypal.com/AdaptivePayments/",
        :beta_sandbox => "https://svcs.beta-sandbox.paypal.com/AdaptivePayments/"
      }[@environment]
      @base_page_url = {
        :production => "https://www.paypal.com",
        :sandbox => "https://www.sandbox.paypal.com",
        :beta_sandbox => "https://www.beta-sandbox.paypal.com"
      }[@environment]
    end

    def retain_requests_for_test?
      !!@retain_requests_for_test
    end

    # send a preapproved payment request to paypal
    def request_preapproval(&block)
      request = PreapprovalRequest.new
      yield request
      perform request
    end

    def request_payment(&block)
      request = PaymentRequest.new
      yield request
      perform request
    end

    def request_refund(&block)
      request = RefundRequest.new
      yield request
      perform request
    end

    def perform(request)
      if retain_requests_for_test?
        self.class.requests << request
        test_response || self.class.test_response
      else
        request.perform self
      end
    end

  end
end
