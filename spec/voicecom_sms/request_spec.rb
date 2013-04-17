require "spec_helper"
require "voicecom_sms/request"

describe VoicecomSms::Request do
  before(:each) do
    @request = VoicecomSms::Request.new
  end

  describe "#new" do
    it "should form the provider's API url" do
      url = @request.uri

      url.hostname.should == VoicecomSms.config.provider_ip
      url.path.sub(/^\//, '').should == VoicecomSms.config.send_req_path
    end
  end

  describe "#params=" do
    it "should add query params to the provider's API url" do
      @request.uri.query.should be_blank

      params = { p1: 1, p2: 'opa' }

      @request.params = params
      @request.uri.query.should == URI.encode_www_form(params)
    end
  end

  describe "#send_message" do
    it "should send an Net::HTTP request" do
      Net::HTTP.should_receive('get_response')
      @request.send_message
    end
  end

  describe "#sent?" do
    it "should be false when the request was not sent" do
      @request.should_not be_sent
    end

    it "should be true when the request was sent" do
      Net::HTTP.should_receive('get_response').and_return { 'some response' }
      @request.send_message
      @request.should be_sent
    end
  end
end
