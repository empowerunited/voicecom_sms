require 'voicecom_sms/message'
require 'voicecom_sms/request'
require 'voicecom_sms/response'

module VoicecomSms
  class Provider
    STATUS = {
      undefined: 0,
      success: 1,
      failure: 2
    }.freeze

    attr_reader :request, :response

    def initialize
      check_config
      @request = VoicecomSms::Request.new
      @response = nil
    end

    def send_sms(number, text)
      message = VoicecomSms::Message.create({text: text, number: normalize_number(number), status: STATUS[:undefined]})

      make_request(message, number, text)


      if @request.error or !@request.sent?
        message.update_attributes(response: @request.error, status: STATUS[:failure])
      else
        @response = VoicecomSms::Response.new(@request.raw_response)
        status = @response.success? ? STATUS[:success] : STATUS[:failure]

        message.update_attributes(response: @response.inspect, status: status, response_received_at: Time.current)
      end

      message.status
    end

    def normalize_number(number)
      number.gsub!(/\s+/, '')
      number.sub!(/^(\+|00)/, '')
      number.sub!(/^0/, '359')
      number
    end

    private
    def make_request(message, number, text)

      @request.params = {
        sid: VoicecomSms.config.client_id,
        id: message.id,
        msisdn: number,
        text: text,
        #priority: 2, # 1 - high priority, 2 - normal priority (default)
        #validity: 1440 # validity period in minutes from 10 to 1440 (default)
      }

      message[:request] = "The request before actual sending: #{@request.inspect}"

      if message.save
        @request.send_message
        message.update_attributes(request: @request.inspect)
      else
        raise VoicecomSms::HistoryError(message)
      end
    end

    def check_config
      %w(send_req_path
      provider_port
      provider_ip
      client_id).each do |setting|
        raise VoicecomSms::ConfigurationError.new("Wrong configuration: #{setting} is blank") if VoicecomSms.config.send(setting).blank?
      end
    end

    def logger
      VoicecomSms.logger
    end

  end
end
