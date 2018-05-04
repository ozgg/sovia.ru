Rails.application.routes.draw do
  scope '(:locale)', constraints: { locale: /ru|en/ } do
    root 'index#index'
  end
end
