require 'active_record'

module VoicecomSms
  class Message < ActiveRecord::Base
    self.table_name = 'voicecom_messages'
  end
end
