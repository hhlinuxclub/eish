# Public and Private keys for reCAPTCHA.
RCC_ENABLED = Setting.option("recaptcha_enabled", :boolean)
RCC_PUB = Setting.option("recaptcha_public_key")
RCC_PRIV = Setting.option("recaptcha_private_key")

# Google Analytics
GA_ENABLED = Setting.option("google_analytics_enabled", :boolean)
GA_TrackerID = Setting.option("google_analytics_tracker_id")

# Xapian
XAPIT_GEM_LOADED = Rails.configuration.gems.detect { |gem| gem.name == "xapit" } ? true : false
SEARCH_ENABLED = XAPIT_GEM_LOADED ? Setting.option("search_enabled", :boolean) : false

HTTPS_ENABLED = Setting.option("https_enabled", :boolean)

FOOTER = Setting.option("footer")