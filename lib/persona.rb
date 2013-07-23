module Persona

  def self.authenticate(assertion, options={})
    server = 'https://verifier.login.persona.org/verify'
    available_audience = ENV['PERSONA_AUDIENCE'].split
    if requested_audience = options[:audience]
      return {status: 'error'}.to_json unless available_audience.include? requested_audience
    end
    assertion_params = {
      assertion: assertion,
      audience: requested_audience || available_audience.first.presence || 'http://0.0.0.0:3000'
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
