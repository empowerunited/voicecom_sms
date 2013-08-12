require "spec_helper"

require "voicecom_sms/provider"
require "voicecom_sms/request"
require "voicecom_sms/response"

describe VoicecomSms::Provider do

  before(:each) do
    DatabaseCleaner.clean
  end

  let(:destination_mobile_number){ '359899947329' }

  describe "#new" do
    it "should create a request instances" do
      provider = VoicecomSms::Provider.new
      provider.request.should be_a VoicecomSms::Request
      provider.response.should be_nil
    end
  end

  describe "#send_sms" do
    before(:each) do
      @provider = VoicecomSms::Provider.new
      stub_request(:get, "https://localhost:8443/smsapi/bsms/index.php?sid=#{VoicecomSms.config.client_id}&id=1&msisdn=359899947329&text=some+message").
        to_return(lambda { |request| File.new("request_stubs/success.curl")})
    end

    it "should create new message record" do
      expect {
        @provider.send_sms(destination_mobile_number, 'some message')
      }.to change(VoicecomSms::Message, :count).by(1)
    end

    it "should set the query params in the request" do
      @provider.request.params.should be_blank
      @provider.send_sms(destination_mobile_number, 'some message')
      @provider.request.params.should_not be_blank
    end

    it "should save the request query in the message" do
      @provider.send_sms(destination_mobile_number, 'some message')
      message = VoicecomSms::Message.last
      message.request.should == @provider.request.inspect
    end

    it "should send the message to the provider's API" do
      @provider.request.should_receive('send_message')
      @provider.send_sms(destination_mobile_number, 'some message')
    end

    it "should save the response in the message" do
      @provider.send_sms(destination_mobile_number, 'some message')

      message = VoicecomSms::Message.last
      message.response.should == @provider.response.inspect
    end

    it "should return the status" do
      result = @provider.send_sms(destination_mobile_number, 'some message')
      result.should == VoicecomSms::Provider::STATUS[:success]
    end
  end

end
