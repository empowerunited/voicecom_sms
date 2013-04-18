require 'net/http'

module VoicecomSms
  class Request
    attr_accessor :uri, :params
    attr_reader :raw_response, :error

    def initialize
      @uri = URI.parse('http://' + VoicecomSms.config.provider_ip + '/' + VoicecomSms.config.send_req_path)
      @params = {}
      @raw_response = nil
      @error = nil
    end

    def params=(query_params)
      @params = query_params
      @uri.query = URI.encode_www_form(@params)
    end

    def send_message
      @raw_response = Net::HTTP.get_response(@uri)
    rescue Exception => e
      @error = e.message
    end

    def sent?
      @error.nil? && @raw_response.present?
    end

    def to_s
      @uri.to_s
    end
  end
end

