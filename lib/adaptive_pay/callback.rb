module AdaptivePay
  class Callback

    def initialize(params)
      @params = params
    end

    def method_missing(name, *args)
      @params[name.to_s] || super
    end

    def completed?
      payment_status == "Completed"
    end

  end
end
