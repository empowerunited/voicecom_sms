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
      url.port.should == VoicecomSms.config.provider_port.to_i
      url.path.should == VoicecomSms.config.send_req_path
    end
  end

end
