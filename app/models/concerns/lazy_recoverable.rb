# Overrides part of Devise::Models::Recoverable
#
# If the devised model has a recent enough token, just use it again!
# This way, the user will get the same token even if they receive two
# password recover email.
module LazyRecoverable
  extend ActiveSupport::Concern

  RESET_PASSWORD_TOKEN_LAZINESS = 20.minutes

  def set_reset_password_token
    # Just cache it! :)
    cache_key = "reset_password_token_hash:#{self.reset_password_token}"
    Rails.cache.fetch(cache_key, expires_in: RESET_PASSWORD_TOKEN_LAZINESS) do
      super
    end
  end
end
