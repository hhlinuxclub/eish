keys = YAML.load_file("#{RAILS_ROOT}/config/keys.yml")

# Public and Private keys for reCAPTCHA.
RCC_ENABLED = false
RCC_PUB = keys["ReCAPTCHA"]["Public"]
RCC_PRIV = keys["ReCAPTCHA"]["Private"]

# Google Analytics
GA_ENABLED = false
GA_TrackerID = keys["GoogleAnalytics"]["Tracker_ID"]

# Enable if you have Xapian and the Xapian Ruby bindings installed.
# You must also load the Xapit plugin in environment.rb.
# An up-to-date index is also a good idea.
SEARCH_ENABLED = false