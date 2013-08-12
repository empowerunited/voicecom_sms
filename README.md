# voicecom_sms

[![Build Status](https://travis-ci.org/empowerunited/voicecom_sms.png?branch=master)](https://travis-ci.org/empowerunited/voicecom_sms)

This is a interface to the VoiceCom SMS API, designed for ruby application.

## Installation & Usage

To include to your rails app, simply add it to gemfile:

    gem 'voicecom_sms'

Then run

    rails generate voicecom_sms database

that should create one migration file and an initializer for the gem.

Next run

    rake db:migrate

and that will create the voicecom_messages table in your database.

Finally open and edit the initializer

    voicecom_sms.rb

by filling your credentials for the VioceCom API

### Rails example

rails c

    @provider = VoicecomSms::Provider.new
    @provider.send_sms('359888889204', "Vashiyat kod e: 1234")


### irb example
irb

    require 'voicecom_sms'
    puts "make sure that you load the schema.rb"

    configuration = VoicecomSms.configure do |config|
      config.provider_ip = ENV['VOICECOM_IP']
      config.provider_port = ENV['VOICECOM_PORT']
      config.client_id = ENV['VOICECOM_CLIENT_ID']
      config.send_req_path = ENV['VOICECOM_SEND_REQUEST_PATH']
      puts "Provider settings https://#{config.provider_ip}:#{config.provider_port}#{config.send_req_path}?id=#{config.send_req_path}"
    end

    @provider = VoicecomSms::Provider.new
    @provider.send_sms('359888889204', "Вашият код е: : 1234")

Note:
The message should match the template you have given to voicecom


## Contributing to voicecom_sms

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2013 Empower United. See LICENSE.txt for further details.

