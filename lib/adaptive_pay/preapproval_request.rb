module AdaptivePay
  class PreapprovalRequest < AbstractPaymentRequest

    def self.response_type
      :preapproval
    end

    def self.endpoint
      "Preapproval"
    end

    attribute "dateOfMonth"
    attribute "dayOfWeek"
    attribute "endingDate", :format => :date
    attribute "startingDate", :format => :date
    attribute "maxAmountPerPayment"
    attribute "maxNumberOfPayments"
    attribute "maxNumberOfPaymentsPerPeriod"
    attribute "maxTotalAmountOfAllPayments"
    attribute "paymentPeriod"
    attribute "pinType"

  end
end
