module Persona

  def self.authenticate(assertion)
    server = 'https://verifier.login.persona.org/verify'
    assertion_params = {
      assertion: assertion,
      audience: ENV['PERSONA_AUDIENCE'] || 'http://0.0.0.0:3000'
    }
    request = RestClient::Resource.new(server, verify_ssl: true).post(assertion_params)
    response = JSON.parse(request)

    if response['status'] == 'okay'
      return response
    else
      ap response
      return {status: 'error'}.to_json
    end
  end

end