module AdaptivePay
  class PaymentRequest < AbstractPaymentRequest

    def self.response_type
      :payment
    end

    def self.endpoint
      "Pay"
    end

    attr_reader :recipients

    attribute "actionType", :default => "PAY"
    attribute "preapprovalKey"
    attribute "pin"
    attribute "feesPayer"
    attribute "logDefaultShippingAddress"
    attribute "reverseAllParallelPaymentsOnError"
    attribute "trackingId"

    def initialize(&block)
      @recipients = []
      super
    end

    def add_recipient(recipient_options)
      if recipient_options.is_a?(AdaptivePay::Recipient)
        @recipients << recipient_options
      else
        @recipients << AdaptivePay::Recipient.new(recipient_options)
      end
    end

    protected
      def extra_attributes
        result = {}
        recipients.each_with_index do |r, i|
          result["receiverList.receiver(#{i}).email"] = r.email
          result["receiverList.receiver(#{i}).amount"] = sprintf "%.2f", r.amount
          result["receiverList.receiver(#{i}).primary"] = r.primary?
        end
        super.merge(result)
      end

  end
end
