OAUTH_CONFIG = YAML.load_file("#{Rails.root}/config/oauth.yml")[Rails.env]

OAUTH_CONFIG.keys.each do |k|
  OAUTH_CONFIG[k.sub(/_file$/, '')] = IO.read(OAUTH_CONFIG[k]) if k =~ /_file$/
end

