module AdaptivePay
  class PaymentRequest < AbstractPaymentRequest

    attribute "actionType", :default => "PAY"
    attribute "preapprovalKey"
    attribute "pin"
    attribute "feesPayer"
    attribute "logDefaultShippingAddress"
    attribute "reverseAllParallelPaymentsOnError"
    attribute "trackingId"

  end
end
