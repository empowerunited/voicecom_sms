module VoicecomSms
  class Response
    attr_reader :status, :message, :body

    def initialize(raw_response)
      @raw_response = raw_response
      @status = raw_response.status
      @body = raw_response.body
    end

    def success?
      return false unless @raw_response
      @raw_response.success? && @body =~ /SEND_OK/ && @body !~ /ERROR/
    end

  end
end
