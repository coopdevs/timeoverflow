InvisibleCaptcha.setup do |config|
  config.timestamp_enabled = !Rails.env.test?
  config.spinner_enabled = !Rails.env.test?
end
