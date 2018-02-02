app_path = File.expand_path(File.dirname(__FILE__) + '/..')

worker_processes 2

listen 8080, tcp_nopush: true

working_directory app_path

pid app_path + '/tmp/unicorn.pid'

stderr_path '/var/www/timeoverflow/shared/log/unicorn.err.log'
stdout_path '/var/www/timeoverflow/shared/log/unicorn.std.log'

# Load the app up before forking
# Combine Ruby 2.0.0+ with "preload_app true" for memory savings
preload_app true

before_fork do |server, worker|
  # the following is highly recomended for Rails + "preload_app true"
  # as there's no need for the master process to hold a connection
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  # the following is *required* for Rails + "preload_app true"
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end
