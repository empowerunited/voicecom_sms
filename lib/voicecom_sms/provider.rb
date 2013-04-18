require 'voicecom_sms/message'
require 'voicecom_sms/request'
require 'voicecom_sms/response'

module VoicecomSms
  class Provider
    STATUS = {
      success: 1,
      failure: 2
    }.freeze

    attr_reader :request, :response

    def initialize
      @request = VoicecomSms::Request.new
      @response = VoicecomSms::Response.new
    end

    def send_sms(number, text)
      message = VoicecomSms::Message.create({text: text, number: normalize_number(number)})

      make_request(message, number, text)

      if @request.error
        message.update_attributes(response: @request.error, status: STATUS[:failure])
      else
        parse_response(message)
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

      message[:request] = request.to_s

      message.save and @request.send_message
    end

    def parse_response(message)
      return unless @request.sent?

      @response.parse(@request.raw_response)
      status = @response.success? ? STATUS[:success] : STATUS[:failure]

      message.update_attributes(
        response: @response.to_s,
        status: status,
        response_received_at: Time.current)
    end
  end
end
