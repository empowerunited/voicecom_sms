require "spec_helper"

require "voicecom_sms/provider"
require "voicecom_sms/request"
require "voicecom_sms/response"

describe VoicecomSms::Provider do
  before(:all) do
    VoicecomSms.configure do |config|
      config.provider_ip = '0.0.0.0'
      config.client_id = 12345
      config.send_req_path = ''
    end
  end

  before(:each) do
    DatabaseCleaner.clean
  end

  describe "#new" do
    it "should create a request and responce instances" do
      provider = VoicecomSms::Provider.new

      provider.request.should be_a VoicecomSms::Request
      provider.response.should be_a VoicecomSms::Response
    end
  end

  describe "#send_sms" do
    before(:all) do
      @provider = VoicecomSms::Provider.new
    end

    it "should create new message" do
      expect {
        @provider.send_sms('0888855224', 'some message')
      }.to change(VoicecomSms::Message, :count).by(1)
    end

    it "should try to convert the number to a valid one" do
      @provider.send_sms('0888855224', 'some message')
      message = VoicecomSms::Message.last
      message.number.should == '359888855224'
    end

    it "should save the request query in the message" do
      @provider.send_sms('08752244433', 'some message')
      message = VoicecomSms::Message.last
      request = message.request

      uri = URI.parse(request)
      uri.hostname.should == VoicecomSms.config.provider_ip
      uri.path.should == VoicecomSms.config.send_req_path

      params = Hash[URI.decode_www_form(uri.query)]

      params['sid'].should == VoicecomSms.config.client_id.to_s
      params['msisdn'].should == '3598752244433'
      params['text'].should == 'some message'
    end

    it "should save the response in the message" do
      @provider.send_sms('08752244433', 'some message')

      message = VoicecomSms::Message.last
      message.response.should =~ /^200 OK: /
      message.response_received_at.should be_within(1.minute).of(Time.current)
      message.status.should == @provider.response.status
    end

    it "should return the status" do
      result = @provider.send_sms('08752244433', 'some message')
      result.should == @provider.response.status
    end
  end

  describe "#normalize_number" do
    before(:all) do
      @provider = VoicecomSms::Provider.new
    end

    it "should convert the number to an acceptable by the API value" do
      acceptable_value = '359888855224'

      @provider.normalize_number('359888855224').should == acceptable_value
      @provider.normalize_number('0888855224').should == acceptable_value
      @provider.normalize_number('00359888855224').should == acceptable_value
      @provider.normalize_number('+359888855224').should == acceptable_value
    end
  end
end
