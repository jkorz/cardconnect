module CardConnect
  module Service
    class AuthorizationResponse
      include Utils

      FIELDS = [:respstat, :retref, :account, :token, :amount, :merchid, :respcode, :binInfo, :bintype, :receipt,
                :resptext, :respproc, :avsresp, :cvvresp, :authcode, :commcard, :profileid, :acctid, :emvTagData].freeze

      attr_accessor(*FIELDS)
      attr_reader :errors, :response

      STATUS_APPROVED = 'A'.freeze
      STATUS_RETRY = 'B'.freeze
      STATUS_DECLINED = 'C'.freeze

      def initialize(response)
        @response = response
        set_attributes(response, FIELDS)
        @errors = []
        process_errors
      end

      def success?
        errors.empty?
      end

      def body
        FIELDS.collect{|attr| {attr => send(attr)} }.reduce({}, :merge)
      end

      private

      def process_errors
        @errors << resptext if [STATUS_RETRY, STATUS_DECLINED].include?(respstat)
      end
    end
  end
end
