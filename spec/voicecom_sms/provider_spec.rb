require "spec_helper"

require "voicecom_sms/provider"
require "voicecom_sms/request"
require "voicecom_sms/response"

describe VoicecomSms::Provider do
  before(:all) do
    VoicecomSms.configure do |config|
      config.provider_ip = '0.0.0.0'
      config.client_id = 12345
    end
  end

  describe "#new" do
    it "should create a request and responce instances" do
      provider = VoicecomSms::Provider.new

      provider.request.should be_a VoicecomSms::Request
      provider.response.should be_a VoicecomSms::Response
    end
  end

  #describe "#send_sms" do
  #  before(:all) do
  #    @provider = VoicecomSms::Provider.new
  #  end
  #
  #  it "should create new message" do
  #    message = double('VoicecomSms::Message')
  #
  #    @provider.send_sms('some message', '359888855224')
  #    message.should_receive(:create)
  #  end
  #
  #  it "should try to convert the number to a valid one" do
  #    provider = double('VoicecomSms::Provider')
  #    provider.should_receive(:normalize_number).with('359888855224')
  #    provider.send_sms('some message', '359888855224')
  #  end
  #
  #  #it "should save the request query in the message"
  #  #it "should send the http request"
  #  #it "should save the request send time in the message"
  #  #it "should parse the response"
  #end

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
