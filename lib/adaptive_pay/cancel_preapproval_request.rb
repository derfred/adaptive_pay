module AdaptivePay
  class CancelPreapprovalRequest < Request

    def self.response_type
      :cancel_preapproval
    end

    def self.endpoint
      "CancelPreapproval"
    end

    attribute "requestEnvelope.errorLanguage", :default => "en_US"
    attribute "preapprovalKey"

  end
end
