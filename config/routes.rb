# frozen_string_literal: true

Rails.application.routes.draw do
  concern :check do
    post :check, on: :collection, defaults: { format: :json }
  end

  concern :toggle do
    post :toggle, on: :member, defaults: { format: :json }
  end

  concern :priority do
    post :priority, on: :member, defaults: { format: :json }
  end

  concern :removable_image do
    delete :image, action: :destroy_image, on: :member, defaults: { format: :json }
  end

  concern :lock do
    member do
      put :lock, defaults: { format: :json }
      delete :lock, action: :unlock, defaults: { format: :json }
    end
  end

  resources :sleep_places, only: %i[update destroy]
  resources :dreams, only: %i[update destroy]

  resources :patterns, only: %i[update destroy]

  scope '(:locale)', constraints: { locale: /ru|en/ } do
    root 'index#index'

    resources :sleep_places, only: %i[new create edit], concerns: :check
    resources :dreams, except: %i[update destroy], concerns: :check

    resources :patterns, only: %i[new create edit], concerns: :check

    scope 'dreambook', controller: :dreambook do
      get '/' => :index, as: :dreambook
      get '/:word' => :word, as: :dreambook_word, constraints: { word: %r{[^/]+} }
    end

    namespace :my do
      resources :sleep_places, only: %i[index show]
      resources :dreams, only: %i[index show]
    end

    namespace :admin do
      resources :dreams, only: %i[index show], concerns: :toggle
      resources :patterns, only: %i[index show]
    end
  end
end
