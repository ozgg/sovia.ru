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

  root 'index#index'

  get 'sitemap' => 'index#sitemap', defaults: { format: :xml }
  get 'sitemap.dreambook' => 'index#sitemap_dreambook', defaults: { format: :xml }
  get 'sitemap.dreams' => 'index#sitemap_dreams', defaults: { format: :xml }
  get 'sitemap.posts' => 'index#sitemap_posts', defaults: { format: :xml }
  get 'sitemap.questions' => 'index#sitemap_questions', defaults: { format: :xml }

  resources :dreams, only: %i[index show]

  scope 'interpretations', controller: :interpretations do
    get '/' => :index, as: :interpretations
  end

  scope 'robokassa', controller: :robokassa do
    post '/' => :create_invoice, as: :robokassa_invoices
    post 'result' => :pay_result, as: nil
    get 'success' => :pay_success, as: nil
    get 'fail' => :pay_fail, as: nil
  end

  scope 'dreambook', controller: :dreambook do
    get '/' => :index, as: :dreambook
    get 'search' => :search, as: :dreambook_search
    get ':word' => :word, as: :dreambook_word, constraints: { word: %r{[^/]+} }
    get ':letter/:word', to: redirect('/dreambook/%{word}')
  end

  namespace :my do
    resources :sleep_places, concerns: :check
    resources :dreams, concerns: :check
    resources :patterns, concerns: :check
    resources :interpretations, only: %i[index create show] do
      post 'messages' => :create_message, on: :member
    end
  end

  namespace :admin do
    resources :dreams, concerns: %i[check toggle]
    resources :fillers, concerns: :check
    resources :sleep_places, only: :index
    resources :patterns, concerns: :check
    resources :interpretations, only: %i[index show], concerns: :toggle do
      post 'messages' => :create_message, on: :member
    end
    resources :robokassa_invoices, only: %i[destroy index show]
  end
end
