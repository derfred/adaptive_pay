module AdaptivePay
  class PaymentRequest < AbstractPaymentRequest

    def self.response_type
      :payment
    end

    attribute "actionType", :default => "PAY"
    attribute "preapprovalKey"
    attribute "pin"
    attribute "feesPayer"
    attribute "logDefaultShippingAddress"
    attribute "reverseAllParallelPaymentsOnError"
    attribute "trackingId"

  end
end
