module VoicecomSms
  class Request
    attr_accessor :uri, :params

    def initialize
      @uri = URI.parse(VoicecomSms.config.provider_ip)
      @params = {}
    end

    def params=(query_params)
      @params = query_params
      @uri.query = URI.encode_www_form(@params)
    end

    def http_send

    end

    def to_s
      @uri.to_s
    end
  end
end

