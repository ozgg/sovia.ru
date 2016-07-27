Rails.application.routes.draw do
  # Toggleable members
  concern :toggleable do
    post 'toggle', on: :member
  end

  # Lockable members
  concern :lockable do
    member do
      put 'lock'
      delete 'lock', action: :unlock
    end
  end

  # Collections that have tags and archive (e.g. posts and dreams)
  concern :tagged_archive do
    collection do
      get 'tagged/:tag_name' => :tagged, as: :tagged
      get 'archive/(:year)/(:month)' => :archive, as: :archive, constraints: { year: /\d{4}/, month: /(\d|1[0-2])/ }
    end
  end

  root 'index#index'

  namespace :admin do
    get '/' => 'index#index'

    resources :browsers, :agents, only: [:index]
    resources :users, :tokens, :codes, only: [:index]
    resources :posts, :tags, only: [:index]
  end

  namespace :api, defaults: { format: :json } do
    resources :browsers, :agents, except: [:new, :edit], concerns: [:toggleable, :lockable]
    resources :users, :tokens, except: [:new, :edit], concerns: [:toggleable]
    resources :posts, except: [:new, :edit], concerns: [:toggleable, :lockable]
  end

  namespace :my do
    get '/' => 'index#index'

    resource :profile, except: [:destroy]
    resource :confirmation, :recovery, only: [:show, :create, :update]

    resources :posts, only: [:index]
  end

  resources :browsers, except: [:index] do
    member do
      get 'agents'
    end
  end
  resources :agents, except: [:index]

  resources :users, except: [:index]
  resources :tokens, :codes, except: [:index]

  resources :posts, except: [:index], concerns: [:tagged_archive]
  resources :figures, only: [:show, :edit, :update, :destroy]
  resources :tags

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
