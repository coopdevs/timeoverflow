# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_token is kept private
# if you're sharing your code publicly.
Rails.application.config.secret_token = ENV['SECRET_TOKEN'] || "8df86bdf5c64ce11154ea056d592ddab1f668c8c6982f1d9e2396c78246d6d7cbe05765684abf9767c41d7ebadc90c05175fc55fddf0ea83e65ee261a41dd631"
