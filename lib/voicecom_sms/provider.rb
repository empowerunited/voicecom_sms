require 'voicecom_sms/message'

module VoicecomSms
  class Provider
    attr_reader :request, :response

    def initialize
      @request = VoicecomSms::Request.new
      @response = VoicecomSms::Response.new
    end

    def send_sms(number, text)
      message = VoicecomSms::Message.create({text: text, number: normalize_number(number)})

      @request.params = {
        sid: VoicecomSms.config.client_id,
        id: message.id,
        msisdn: number,
        text: text,
        #priority: 2, # 1 - high priority, 2 - normal priority (default)
        #validity: 1440 # validity period in minutes from 10 to 1440 (default)
      }

      message.update_attribute :request, request.to_s

      if message.save
        @response.parse(@request.send_message)
        message.update_attributes(
          response: response.to_s,
          status: response.status,
          response_received_at: Time.current
        )
        response.status
      end
    end

    def normalize_number(number)
      number.gsub!(/\s+/, '')
      number.sub!(/^(\+|00)/, '')
      number.sub!(/^0/, '359')
      number
    end
  end
end
