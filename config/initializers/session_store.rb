# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_caerus_session',
  :secret      => '0f7e7de3159aeb11feed27f610deb4c7cdb297920df3ad700093bf9d3d39258805a89266cdd9da7dc7d61ca4be79cf5c6a2f3b588b27dd5c96c650df30d5a301'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
