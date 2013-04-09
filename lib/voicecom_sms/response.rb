module VoicecomSms
  class Response
    attr_reader :status

    def parse(raw_response)
      @code = raw_response.code
      @message = raw_response.message
      @body = raw_response.body
      @status = raw_response.is_a?(Net::HTTPSuccess) && @body == 'SEND_OK' ? 1 : 2
    end

    def to_s
      "#@code #@message: #@body"
    end
  end
end
