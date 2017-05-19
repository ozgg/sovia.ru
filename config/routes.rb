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
    get 'dreams', on: :member
  end

  concern :list_of_comments do
    get 'comments', on: :member
  end

  mount Biovision::Base::Engine, at: '/'
  mount Biovision::Vote::Engine, at: '/'

  root 'index#index'

  get 'dreams/random' => 'dreams#random', as: :random_dream

  namespace :admin do
    get '/' => 'index#index'

    resources :users, only: [:index, :show], concerns: [:list_of_dreams, :list_of_comments] do
      member do
        get 'tokens'
        get 'codes'
        get 'posts'
      end
    end

    resources :posts, only: [:index, :show], concerns: [:list_of_comments]
    resources :tags, only: [:index, :show]
    resources :comments, only: [:index, :show]
    resources :questions, only: [:index, :show], concerns: [:list_of_comments]

    resources :grain_categories, only: [:index, :show]
    resources :patterns, only: [:index, :show], concerns: [:list_of_dreams]
    resources :words, only: [:index, :show], concerns: [:list_of_dreams]

    resources :dreams, only: [:index, :show], concerns: [:list_of_comments]
    resources :fillers, only: [:index, :show]

    resources :violations, only: [:index, :show]
    resources :search_queries, only: [:index]
  end

  namespace :api, defaults: { format: :json } do
    resources :browsers, :agents, except: [:new, :edit], concerns: [:toggleable, :lockable]
    resources :users, :tokens, except: [:new, :edit], concerns: [:toggleable]
    resources :posts, except: [:new, :edit], concerns: [:toggleable, :lockable]
    resources :comments, except: [:new, :edit], concerns: [:toggleable, :lockable]
    resources :patterns, except: [:new, :edit], concerns: [:toggleable, :lockable]
    resources :words, except: [:new, :edit], concerns: [:toggleable, :lockable] do
      put 'patterns', on: :member
    end
    resources :grain_categories, except: [:new, :edit], concerns: [:lockable]
    resources :dreams, except: [:new, :edit], concerns: [:toggleable] do
      get 'interpretation', on: :member
    end
    resources :questions, except: [:new, :edit], concerns: [:lockable]
  end

  namespace :my do
    get '/' => 'index#index'

    resource :profile, except: [:destroy]
    resource :confirmation, :recovery, only: [:show, :create, :update]

    resources :places, only: [:index, :show], concerns: [:list_of_dreams]
    resources :grains, only: [:index, :show], concerns: [:list_of_dreams]
    resources :dreams, only: [:index]
    resources :posts, only: [:index]
    resources :comments, only: [:index]
    resources :questions, only: [:index]
  end

  resources :browsers, :agents, except: [:index, :show]

  resources :users, except: [:index, :show]
  resources :tokens, :codes, except: [:index, :show]

  resources :places, except: [:index, :show]
  resources :grain_categories, :grains, except: [:index, :show]

  resources :posts, concerns: [:tagged_archive]
  resources :figures, only: [:show, :edit, :update, :destroy]
  resources :tags
  resources :comments, except: [:index, :new]
  resources :patterns, except: [:index, :show]
  resources :words, except: [:index, :show]
  resources :dreams, concerns: [:tagged_archive]
  resources :questions
  resources :fillers, except: [:index, :show]

  scope 'dreambook', controller: :dreambook do
    get '/' => :index, as: :dreambook
    get '/search' => :search, as: :dreambook_search
    get '/:word' => :word, as: :dreambook_word, constraints: { word: /[^\/]+/ }
    get '/:letter/:word' => :word, constraints: { word: /[^\/]+/ }
  end

  controller :authentication do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
    get 'auth/:provider' => :auth_external, as: :auth_external
    # get 'auth/:provider/callback' => :callback, as: :auth_callback
  end

  controller :about do
    get 'about' => :index
    get 'tos' => :tos
  end

  # Public user profile
  scope 'u/:slug', controller: :profiles do
    get 'dreams', as: :user_dreams
    get 'posts', as: :user_posts
    get 'questions', as: :user_questions
    get 'comments', as: :user_comments
  end

  # Obsolete routes

  scope 'statistics', controller: :statistics do
    get '/' => :index, as: :statistics
    get 'patterns' => :patterns, as: :statistics_patterns
  end

  get 'sitemap', to: redirect('/sitemap.xml')
  get 'about/features', to: redirect('/about')
  get 'articles', to: redirect('/posts')
  get 'articles/:id', to: redirect('/posts/%{id}')
  get 'articles/tagged/:tag', to: redirect('/posts')
  get 'forum/posts/:id', to: redirect('/posts/%{id}')
  get 'forum/(:community)(/:id)', to: redirect('/posts')
  get 'privacy', to: redirect('/tos')
  get 'statistics/symbols', to: redirect('/statistics/patterns')
end
