# This file is used by Rack-based servers to start the application.
Encoding.default_internal = 'utf-8'
Encoding.default_external = 'utf-8'
require ::File.expand_path('../config/environment',  __FILE__)
run Rails.application
