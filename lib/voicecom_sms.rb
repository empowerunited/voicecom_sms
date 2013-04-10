require 'voicecom_sms/provider'
require 'voicecom_sms/request'
require 'voicecom_sms/response'
require 'voicecom_sms/message'

require 'hashie/mash'

module VoicecomSms

  @config = Hashie::Mash.new

  def self.configure
    if block_given?
      yield @config
    end
  end

  def self.config(*args)
    if args.empty?
      @config
    else
      @config.send(args[0].to_sym)
    end
  end
end
