module AdaptivePay
  class ApprovalRequest < AbstractPaymentRequest

    attr_accessor :valid_from, :valid_until

  end
end
