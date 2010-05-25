# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_eish_session',
  :secret      => '6a61b7c1f588f6a715719457bec22dd92c456604507f1f3d99e5378980558e1db1949a10769acb8e247db594330b697dbc59d7fcdba926c8ff19140d1840f724'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
