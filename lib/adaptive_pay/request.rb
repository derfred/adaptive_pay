module AdaptivePay
  class Request

    def initialize(&block)
      yield self if block_given?
    end

  end
end
