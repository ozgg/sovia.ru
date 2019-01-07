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

  resources :dreambook_entries, only: %i[update destroy]
  resources :patterns, :words, only: %i[update destroy]

  resources :sleep_places, only: %i[update destroy]
  resources :dreams, only: %i[update destroy]

  scope 'dreambook', controller: :dreambook do
    get '/' => :index, as: :dreambook
    get '/search' => :search, as: :dreambook_search
    get '/:word' => :word, as: :dreambook_word, constraints: { word: %r{[^/]+} }
    get '/:letter/:word' => :word, constraints: { word: %r{[^/]+} }
  end

  scope '(:locale)', constraints: { locale: /ru|en/ } do
    root 'index#index'

    resources :dreambook_entries, only: %i[new create edit], concerns: %i[check]
    resources :patterns, :words, only: %i[new create edit], concerns: %i[check]

    resources :sleep_places, only: %i[new create edit], concerns: %i[check]
    resources :dreams, except: %i[update destroy], concerns: %i[check]

    namespace :my do
      resources :sleep_places, only: %i[index show]
      resources :dreams, only: %i[index show]
    end

    namespace :admin do
      resources :dreambook_entries, only: %i[index show], concerns: %i[toggle]
      resources :patterns, :words, only: %i[index show]

      resources :dreams, only: %i[index show], concerns: %i[toggle]
    end
  end
end
