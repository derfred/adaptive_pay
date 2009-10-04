module AdaptivePay
  class AbstractPaymentRequest < Request

    attribute "requestEnvelope.detailLevel"
    attribute "requestEnvelope.errorLanguage", :default => "en_US"

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
    attribute "senderEmail"

    attr_reader :sender

    def sender=(sender_options)
      if sender_options.is_a?(AdaptivePay::Sender)
        @sender = sender_options
      else
        @sender = AdaptivePay::Sender.new sender_options
      end
    end

    protected
      def extra_attributes
        return super if sender.blank?
        result = {}
        result["clientDetails.ipAddress"] = sender.client_ip
        result["senderEmail"] = sender.email unless sender.email.blank?
        super.merge(result)
      end

  end
end
