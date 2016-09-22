Rails.application.routes.draw do
  concern :toggleable do
    post 'toggle', on: :member
  end

  concern :lockable do
    member do
      put 'lock'
      delete 'lock', action: :unlock
    end
  end

  concern :tagged_archive do
    collection do
      get 'tagged/:tag_name' => :tagged, as: :tagged
      get 'archive/(:year)/(:month)' => :archive, as: :archive, constraints: { year: /\d{4}/, month: /(\d|1[0-2])/ }
    end
  end

  concern :list_of_dreams do
    member do
      get 'dreams'
    end
  end

  concern :list_of_comments do
    member do
      get 'comments'
    end
  end

  root 'index#index'

  namespace :admin do
    get '/' => 'index#index'

    resources :browsers, only: [:index, :show] do
      member do
        get 'agents'
      end
    end
    resources :agents, only: [:index, :show]

    resources :users, only: [:index, :show], concerns: [:list_of_dreams, :list_of_comments] do
      member do
        get 'tokens'
        get 'codes'
        get 'posts'
      end
    end
    resources :tokens, :codes, only: [:index, :show]

    resources :posts, only: [:index, :show], concerns: [:list_of_comments]
    resources :tags, only: [:index, :show]
    resources :comments, only: [:index, :show]

    resources :patterns, only: [:index, :show], concerns: [:list_of_dreams, :list_of_comments]
    resources :words, only: [:index, :show], concerns: [:list_of_dreams]
  end

  namespace :api, defaults: { format: :json } do
    resources :browsers, :agents, except: [:new, :edit], concerns: [:toggleable, :lockable]
    resources :users, :tokens, except: [:new, :edit], concerns: [:toggleable]
    resources :posts, except: [:new, :edit], concerns: [:toggleable, :lockable]
    resources :comments, except: [:new, :edit], concerns: [:toggleable, :lockable]
    resources :patterns, except: [:new, :edit], concerns: [:toggleable, :lockable]
    resources :words, except: [:new, :edit], concerns: [:toggleable, :lockable]
  end

  namespace :my do
    get '/' => 'index#index'

    resource :profile, except: [:destroy]
    resource :confirmation, :recovery, only: [:show, :create, :update]

    resources :dreams, only: [:index]
    resources :posts, only: [:index]
    resources :comments, only: [:index]
  end

  resources :browsers, :agents, except: [:index, :show]

  resources :users, except: [:index, :show]
  resources :tokens, :codes, except: [:index, :show]

  resources :posts, concerns: [:tagged_archive]
  resources :figures, only: [:show, :edit, :update, :destroy]
  resources :tags
  resources :comments, except: [:index, :new]
  resources :patterns, except: [:index]
  resources :words, except: [:index, :show]

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
