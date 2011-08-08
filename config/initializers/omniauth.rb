Rails.application.config.middleware.use OmniAuth::Builder do
  #provider :twitter, Rails.application.config.authentications_twitter_id, 'QgHbgZSNFO0qJviiMNfyI9dzfje3hr1M4pT7pGu4'
  provider :twitter, APP_CONFIG['twitter_id'], APP_CONFIG['twitter_secret']
  provider :facebook, '213149395402088', '47c8fc981bdd75e6acfb422d3f58aa77'
  
  #OmniAuth.config.full_host = "http://127.0.0.1:3000"
end