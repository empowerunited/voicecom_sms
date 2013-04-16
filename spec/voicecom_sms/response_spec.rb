require "spec_helper"
require "voicecom_sms/response"

describe VoicecomSms::Response do
  include_context :http_response

  before(:each) do
    @response = VoicecomSms::Response.new
  end

  describe "#success?" do
    it "should return true, when parsed a success raw response" do
      @response.should_not be_success
      @response.parse(http_success_double)
      @response.should be_success
    end
  end
end
