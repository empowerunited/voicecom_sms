shared_context (:http_response) do
  let(:http_success_double) {
    http_success_double = double(Net::HTTPSuccess)

    http_success_double.stub!('code')    { 200              }
    http_success_double.stub!('message') { 'OK'             }
    http_success_double.stub!('body')    { 'SEND_OK'        }
    http_success_double.stub!('is_a?')   { Net::HTTPSuccess }

    http_success_double
  }
end
