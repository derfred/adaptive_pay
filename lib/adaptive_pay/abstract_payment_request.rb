module AdaptivePay
  class AbstractPaymentRequest < Request

    attribute "requestEnvelope.detailLevel"
    attribute "requestEnvelope.errorLanguage"

    attribute "clientDetails.ipAddress"
    attribute "clientDetails.applicationId"
    attribute "clientDetails.customerId"
    attribute "clientDetails.customerType"
    attribute "clientDetails.deviceId"
    attribute "clientDetails.geoLocation"
    attribute "clientDetails.model"
    attribute "clientDetails.partnerName"

    attribute "currencyCode"
    attribute "ipnNotificationUrl"
    attribute "cancelUrl"
    attribute "returnUrl"

    attribute "memo"

    attr_reader :sender, :recipients

    def initialize(&block)
      @recipients = []
      super
    end

    def sender=(sender_options)
      if sender_options.is_a?(AdaptivePay::Sender)
        @sender = sender_options
      else
        @sender = AdaptivePay::Sender.new sender_options
      end
    end

    def add_recipient(recipient_options)
      if recipient_options.is_a?(AdaptivePay::Recipient)
        @recipients << recipient_options
      else
        @recipients << AdaptivePay::Recipient.new(recipient_options)
      end
    end

  end
end
