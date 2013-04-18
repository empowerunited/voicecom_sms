require 'net/http'

module VoicecomSms
  class Request
    attr_accessor :uri, :params
    attr_reader :raw_response, :error

    def initialize
      @uri = URI.parse('https://' + VoicecomSms.config.provider_ip + ':8443/' + VoicecomSms.config.send_req_path)
      @params = {}
      @raw_response = nil
      @error = nil
    end

    def params=(query_params)
      @params = query_params
      @uri.query = URI.encode_www_form(@params)
    end

    def send_message
      https = Net::HTTP.new(@uri.host, @uri.port)
      https.use_ssl = true
      https.verify_mode = OpenSSL::SSL::VERIFY_NONE # you may put here VERIFY_PEER instead, but make sure to load the provider's certificate (more: http://martinottenwaelter.fr/2010/12/ruby19-and-the-ssl-error/)

      request = Net::HTTP::Get.new(@uri.path)
      request.set_form_data(@params)

      @raw_response = https.request(@uri.path)
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

