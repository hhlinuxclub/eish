keys = YAML.load_file("#{RAILS_ROOT}/config/keys.yml")

# Public and Private keys for reCAPTCHA.
RCC_ENABLED = false
RCC_PUB = keys["ReCAPTCHA"]["Public"]
RCC_PRIV = keys["ReCAPTCHA"]["Private"]

Rubaidh::GoogleAnalytics.tracker_id   = keys["GoogleAnalytics"]["Tracker_ID"]
Rubaidh::GoogleAnalytics.domain_name  = "example.org"
Rubaidh::GoogleAnalytics.environments = ["development"] # use [] to disable


# Enable if you have Xapian and the Xapian Ruby bindings installed.
# An up-to-date index is also a good idea.
SEARCH_ENABLED = false