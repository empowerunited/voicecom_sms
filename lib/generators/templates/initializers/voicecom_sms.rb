module VoicecomSms
  configure do |config|
    #The GET request should be in the following format:
    #
    #http://<<VoiceCom_IP1>>/<<PATH>>/<<script>>?sid=3&id=cd27526e4afd5c6c331ebdd23d4b3f03&msisdn=359885100407&text=test%20message&op=1&priority=2&validity=1440
    #
    #<VoiceCom_IP1> - IP address of VoiceCom PLC SMS gateway node
    #/<<PATH>>/<<script>> - SCRIPT_URL of the script receiving the requests

    # This is the VoiceCom_IP1 part from the request url
    config.provider_ip = '0.0.0.0'

    # This is the SCRIPT_URL part from the request url
    config.send_req_path = ''

    # That's your unique identifier in the Voicecom system
    config.client_id = nil
  end
end
