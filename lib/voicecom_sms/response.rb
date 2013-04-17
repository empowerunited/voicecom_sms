module VoicecomSms
  class Response
    attr_reader :code, :message, :body

    def parse(raw_response)
      @raw_response = raw_response
      @code = raw_response.code
      @message = raw_response.message
      @body = raw_response.body
    end

    def success?
      @raw_response.is_a?(Net::HTTPSuccess) && @body == 'SEND_OK'
    end

    def to_s
      "#@code #@message: #@body"
    end
  end
end
