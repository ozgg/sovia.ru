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

  get 'sitemap' => 'index#sitemap', defaults: { format: :xml }
  get 'sitemap.dreambook' => 'index#sitemap_dreambook', defaults: { format: :xml }
  get 'sitemap.dreams' => 'index#sitemap_dreams', defaults: { format: :xml }
  get 'sitemap.posts' => 'index#sitemap_posts', defaults: { format: :xml }
  get 'sitemap.questions' => 'index#sitemap_questions', defaults: { format: :xml }

  resources :sleep_places, only: %i[update destroy]
  resources :dreams, only: %i[update destroy]
  resources :fillers, only: %i[destroy update]

  resources :patterns, only: %i[update destroy]

  scope '(:locale)', constraints: { locale: /ru|en/ } do
    root 'index#index'

    scope 'interpretations', controller: :interpretations do
      get '/' => :index, as: :interpretations
      get 'paypal' => :paypal
    end

    scope 'paypal', controller: :paypal do
      post '/' => :hook, as: :nil
      post 'invoices' => :create_invoice, as: :paypal_invoices
      get 'done'
    end

    resources :sleep_places, only: %i[new create edit], concerns: :check
    resources :dreams, except: %i[update destroy], concerns: :check
    resources :fillers, only: %i[create edit new], concerns: :check

    resources :patterns, only: %i[new create edit], concerns: :check

    scope 'dreambook', controller: :dreambook do
      get '/' => :index, as: :dreambook
      get 'search' => :search, as: :dreambook_search
      get ':word' => :word, as: :dreambook_word, constraints: { word: %r{[^/]+} }
    end

    namespace :my do
      resources :sleep_places, only: %i[index show]
      resources :dreams, only: %i[index show]
      resources :interpretations, only: %i[index create show] do
        post 'messages' => :create_message, on: :member
      end
    end

    namespace :admin do
      resources :dreams, only: %i[index show], concerns: :toggle
      resources :fillers, only: %i[index show]
      resources :sleep_places, only: :index
      resources :dreambook_queries, only: :index
      resources :patterns, only: %i[index show]
      resources :pending_patterns, only: :index do
        post 'enqueue', on: :collection
        post 'summary', on: :member
      end
      resources :interpretations, only: %i[index show], concerns: :toggle do
        post 'messages' => :create_message, on: :member
      end
    end
  end
end
