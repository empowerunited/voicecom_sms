require 'net/http'
require 'faraday'

module VoicecomSms
  class Request
    attr_accessor :uri, :params
    attr_reader :raw_response, :error

    def initialize
      @uri = URI.parse('https://' + VoicecomSms.config.provider_ip + ":" + VoicecomSms.config.provider_port + VoicecomSms.config.send_req_path)

      @connection = Faraday.new(:url => @uri, :ssl => {:verify => false}, timeout: 4, open_timeout: 2) do |faraday|
        faraday.request  :url_encoded             # form-encode POST params
        # faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end

      @params = {}
      @raw_response = nil
      @error = nil
    end

    def send_message
      @raw_response = @connection.get  do |request|
        request.url @uri.path
        request.params = @params
      end

      @raw_response
    rescue Exception => e
      @error = e.message
    end

    def sent?
      @raw_response.present?
    end

    def logger
      VoicecomSms.logger
    end

  end
end