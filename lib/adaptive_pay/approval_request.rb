module AdaptivePay
  class ApprovalRequest < AbstractPaymentRequest

    attribute "dateOfMonth"
    attribute "dayOfWeek"
    attribute "endingDate"
    attribute "startingDate"
    attribute "maxAmountPerPayment"
    attribute "maxNumberOfPayments"
    attribute "maxNumberOfPaymentsPerPeriod"
    attribute "maxTotalAmountOfAllPayments"
    attribute "paymentPeriod"
    attribute "pinType"

  end
end
