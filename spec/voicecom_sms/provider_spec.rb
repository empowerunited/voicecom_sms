require "spec_helper"

require "voicecom_sms/provider"
require "voicecom_sms/request"
require "voicecom_sms/response"

describe VoicecomSms::Provider do
  include_context :http_response

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
    before(:each) do
      @provider = VoicecomSms::Provider.new

      # be sure not to send any real requests
      Net::HTTP.stub('get_response')
    end

    it "should create new message record" do
      expect {
        @provider.send_sms('0888855224', 'some message')
      }.to change(VoicecomSms::Message, :count).by(1)
    end

    it "should try to convert the number to a valid one" do
      @provider.send_sms('0888855224', 'some message')
      message = VoicecomSms::Message.last
      message.number.should == '359888855224'
    end

    it "should set the query params in the request" do
      @provider.request.params.should be_blank
      @provider.send_sms('0888855224', 'some message')
      @provider.request.params.should_not be_blank
    end

    it "should save the request query in the message" do
      @provider.send_sms('08752244433', 'some message')
      message = VoicecomSms::Message.last
      message.request.should == @provider.request.to_s
    end

    it "should send the message to the provider's API" do
      @provider.request.should_receive('send_message')
      @provider.send_sms('0888855224', 'some message')
    end

    it "should save the response in the message" do
      Net::HTTP.stub('get_response') { http_success_double }
      @provider.send_sms('08752244433', 'some message')

      message = VoicecomSms::Message.last
      message.response.should == @provider.response.to_s
    end

    it "should return the status" do
      Net::HTTP.stub('get_response') { http_success_double }

      result = @provider.send_sms('08752244433', 'some message')
      result.should == VoicecomSms::Provider::STATUS[:success]
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
