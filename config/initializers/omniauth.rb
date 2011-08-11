Rails.application.config.middleware.use OmniAuth::Builder do
  #provider :twitter, Rails.application.config.authentications_twitter_id, 'QgHbgZSNFO0qJviiMNfyI9dzfje3hr1M4pT7pGu4'
  provider :twitter, APP_CONFIG['twitter_id'], APP_CONFIG['twitter_secret']
  provider :facebook, APP_CONFIG['facebook_id'], APP_CONFIG['facebook_secret']
  
  #OmniAuth.config.full_host = "http://127.0.0.1:3000"
end