# voicecom_sms

[![Build Status](https://travis-ci.org/zzeni/voicecom_sms.png)](https://travis-ci.org/zzeni/voicecom_sms)

This ia a simple interface to the VoiceCom SMS API, designed for rails applications.

## Installation & Usage

To include to your rails app, simply add it to gemfile:

    gem 'voicecom_sms'

Then run

    rails generate voicecom_sms

that should create one migration file and an initializer for the gem.

Next run

    rake db:migrate

and that will create the voicecom_messages table in your database.

Finally open and edit the initializer

    voicecom_sms.rb

by filling your credentials for the VioceCom API

Enjoy :)

## Contributing to voicecom_sms

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2013 Evgenia Manolova. See LICENSE.txt for
further details.

