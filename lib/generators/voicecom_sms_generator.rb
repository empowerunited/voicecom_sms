require 'rails/generators/active_record'

class VoicecomSmsGenerator < ActiveRecord::Generators::Base
  include Rails::Generators::Migration

  TEMPLATES_PATH = File.expand_path('../templates', __FILE__)
  source_root File.expand_path('../../friendly_id', __FILE__)
  #source_root File.expand_path(VoicecomSms::Engine.root, __FILE__)

  def copy_files(*args)
    Dir["#{TEMPLATES_PATH}/migrations/*"].each do |template_file|
      migration_template template_file, "db/migrate/#{File.basename(template_file)}"
    end

    copy_file "#{TEMPLATES_PATH}/initializers/voicecom_sms.rb", 'config/initializers/voicecom_sms.rb'
  end
end
