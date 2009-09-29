module AdaptivePay
  class AbstractPaymentRequest < Request

    attr_accessor :currency, :reverse_all_parallel_payments_on_error, :cancel_url, :return_url, :ipn_url
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
