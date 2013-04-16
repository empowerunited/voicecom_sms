$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'voicecom_sms'
require 'database_cleaner'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

DatabaseCleaner.strategy = :truncation

RSpec.configure do |config|
  config.mock_with :rspec
end

VoicecomSms.configure do |config|
  config.provider_ip = '0.0.0.0'
  config.client_id = 12345
  config.send_req_path = 'test'
end


ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:' # File.dirname(__FILE__) + '/faraday_test.sqlite3'
)

ActiveRecord::Schema.define do
  self.verbose = false

  create_table :voicecom_messages do |t|
    t.string :number, null: false
    t.string :text, null: false
    t.integer :operator
    t.integer :validity
    t.integer :priority
    t.text :hlr
    t.text :request
    t.text :response
    t.datetime :response_received_at
    t.integer :status, default: 0 # 0 - pending, 1 - success, 2 - failed

    #t.text :delivery_request
    #t.text :delivery_response
    #t.datetime :delivery_response_received_at
    #t.integer :delivery_status, default: 0 # 0 - pending, 1 - success, 2 - failed

    t.boolean :delivered, default: false

    t.timestamps
  end
end
