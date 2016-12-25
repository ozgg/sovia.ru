Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV['TWITTER_API_KEY'], ENV['TWITTER_API_SECRET'], {
      secure_image_url: true,
      image_size: 'original'
  }

  provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET'], {
      scope: 'email,public_profile',
      image_size: 'large',
      secure_image_url: true
  }

  provider :vkontakte, ENV['VKONTAKTE_APP_ID'], ENV['VKONTAKTE_APP_SECRET'], {
      scope: 'email'
  }

  provider :mail_ru, ENV['MAIL_RU_APP_ID'], ENV['MAIL_RU_PRIVATE_KEY'], {
      mode: :basic_auth
  }
end
