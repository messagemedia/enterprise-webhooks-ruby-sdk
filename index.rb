require 'sinatra'
require 'base64'
require 'json'

post '/' do
	# An example of what each field should look like has been added next to the corresponding field
	request_line = 'POST / HTTP/1.1'
	body =  request.body.read # {"vendor_account_id":{"vendor_id":"MessageMedia","account_id":"MessageMedia123"},"callback_url":"https://9d2d6d69.ngrok.io/","delivery_report_id":"dc6f7774-9572-41a8-9a6b-9976a98db4a9","source_number":"+61412123123","date_received":"2018-07-18T06:33:51.785Z","status":"delivered","delay":0,"submitted_date":"2018-07-18T06:33:50.792Z","original_text":"Hello!","message_id":"38a6a1a0-36a9-4117-aaee-c0e893393634","error_code":"220","metadata":{}}
	signature = Base64.decode64(request.env["HTTP_X_MESSAGEMEDIA_SIGNATURE"]) # g5ciIx+pWaT7p3ZeGmWKFqx3z2LmBdaMweCdL7+Lv0+4TBS4Ccdp7yxbgBOZp8XXwNPlTCnVeV0MDdHia32kvs3s77fLoInR/C0EKQTo+1hD0m5qKE8DzC5jCRtYiBNuoTYjjwrrfuz/0KTTeRzsZt/PC/4lF1u4fcYTkIlEy+4nf/QdRCs2AgFWEGATEx7UCrTPgwxoKXZXEkoicWhFIKnY4mRCITbNYQmPAmbaW1vLzbqJiy7z7zRL+a4qXOvj341dCGieo8Rkq5sfpJUXdv7rz+PINwhJaqWOoK/wj0n2iT3fd0eLRoyDl9YBznJDlME5XgveQuE8gdU1hzIiag==
	digest = OpenSSL::Digest::SHA256.new # SHA256
	date = request.env["HTTP_DATE"] # Wed, 18 Jul 2018 06:33:52 GMT

	# Construct message
	message = request_line + date + body

	# Read public key from file
	public_key = OpenSSL::PKey::RSA.new File.read 'public_key.pem'
	if public_key.verify(digest, signature, message)
	    p "Verification Successful"
	else
	    p "Verification Failed"
	end
end
