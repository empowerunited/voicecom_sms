module VoicecomSms
  class Error < StandardError
  end

  class ConfigurationError < Error
  end

  class HttpError < Error
  end

  class HistoryError < Error
    def initialize object
      super("Can't save message because of #{object.errors.inspect}")
    end
  end

end
