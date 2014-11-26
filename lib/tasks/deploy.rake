require 'net/http'
require 'rubygems'
require 'json'

namespace :rollbar do

  desc 'Send the deployment notification to Rollbar.'
  task :deploy do
    uri    = URI.parse 'https://api.rollbar.com/api/1/deploy/'
    params = {
      :local_username => ENV['DEPLOY_AUTHOR'],
      :access_token   => Rails.application.secrets.rollbar_access_token,
      :environment    => ENV['RAILS_ENV'],
      :revision       => ENV['DEPLOYED_REVISION'] }

    puts "Building Rollbar POST to #{uri} with #{params.inspect}"

    request      = Net::HTTP::Post.new(uri.request_uri)
    request.body = JSON.dump(params)

    Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |http|
      http.request(request)
    end

    puts 'Rollbar notification complete.'
  end
end
