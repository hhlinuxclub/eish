keys = YAML.load_file("#{RAILS_ROOT}/config/keys.yml")

# Public and Private keys for reCAPTCHA.
RCC_ENABLED = false
RCC_PUB = keys["ReCAPTCHA"]["Public"]
RCC_PRIV = keys["ReCAPTCHA"]["Private"]