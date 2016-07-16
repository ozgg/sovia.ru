Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, Rails.application.secrets.twitter['api_key'], Rails.application.secrets.twitter['api_secret'], {
      secure_image_url: true,
      image_size: 'original'
  }

  provider :facebook, Rails.application.secrets.facebook['app_id'], Rails.application.secrets.facebook['app_secret'], {
      scope: 'email,public_profile',
      image_size: 'large',
      secure_image_url: true
  }

  provider :vkontakte, Rails.application.secrets.vkontakte['app_id'], Rails.application.secrets.vkontakte['app_secret'], {
      scope: 'email'
  }
end
