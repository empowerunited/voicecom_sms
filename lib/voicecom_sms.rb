require 'voicecom_sms/provider'
require 'voicecom_sms/request'
require 'voicecom_sms/response'
require 'voicecom_sms/message'

require 'hashie/mash'
require 'logger'

module VoicecomSms

  @config = Hashie::Mash.new

  class << self

    def configure
      if block_given?
        yield @config
      end
    end

    def config(*args)
      if args.empty?
        @config
      else
        @config.send(args[0].to_sym)
      end
    end

    def logger
      return @@logger if defined? @@logger
      @@logger = Rails.logger if defined? Rails
      # ActiveRecord::Base.logger = Logger.new(STDERR)
      @@logger = Logger.new(STDOUT)
      @@logger.level = Logger::DEBUG
      @@logger
    end
  end

end
