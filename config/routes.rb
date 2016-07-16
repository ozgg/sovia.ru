Rails.application.routes.draw do
  # Toggleable members
  concern :toggleable do
    post 'toggle', on: :member
  end

  # Lockable members
  concern :lockable do
    member do
      put 'lock', as: :lock
      delete 'lock', as: :unlock
    end
  end

  root 'index#index'

  namespace :admin do
    get '/' => 'index#index'

    resources :browsers, :agents, only: [:index]
    resources :users, :tokens, :codes, only: [:index]
  end

  namespace :api, defaults: { format: :json } do
    resources :browsers, :agents, concerns: [:toggleable, :lockable]
    resources :users, :tokens, concerns: [:toggleable]
  end

  namespace :my do
    resource :profile, except: [:destroy]
    resource :confirmation, :recovery, only: [:show, :create, :update]

    get '/' => 'index#index'
  end

  resources :browsers, except: [:index] do
    member do
      get 'agents'
    end
  end
  resources :agents, except: [:index]

  resources :users, except: [:index]
  resources :tokens, :codes, except: [:index]

  controller :authentication do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
    get 'auth/:provider' => :auth_external, as: :auth_external
    get 'auth/:provider/callback' => :callback, as: :auth_callback
  end

  # Public user profile
  scope 'u/:slug', controller: :profiles do
    get '/' => :show, as: :user_profile
  end
end
