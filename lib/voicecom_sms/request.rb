require 'net/http'

module VoicecomSms
  class Request
    attr_accessor :uri, :params
    attr_reader :raw_response

    def initialize
      @uri = URI.parse('http://' + VoicecomSms.config.provider_ip + '/' + VoicecomSms.config.send_req_path)
      @params = {}
      @raw_response = nil
    end

    def params=(query_params)
      @params = query_params
      @uri.query = URI.encode_www_form(@params)
    end

    def send_message
      @raw_response = Net::HTTP.get_response(@uri)
    end

    def sent?
      @raw_response.present?
    end

    def to_s
      @uri.to_s
    end
  end
end

