Rails.application.routes.draw do
  # Toggle entity flag
  concern :toggle do
    post :toggle, on: :member, defaults: { format: :json }
  end

  # Check entity state
  concern :check do
    post :check, on: :collection, defaults: { format: :json }
  end

  # Change entity priority
  concern :priority do
    post :priority, on: :member, defaults: { format: :json }
  end

  resources :sleep_places, only: %i[update destroy]

  scope '(:locale)', constraints: { locale: /ru|en/ } do
    root 'index#index'

    resources :sleep_places, only: %i[new create edit], concerns: %i[check]

    namespace :my do
      resources :sleep_places, only: %i[index show]
    end
  end
end
