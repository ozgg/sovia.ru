Sovia::Application.routes.draw do
  get '/:locale' => 'index#index', constraints: { locale: /ru|en/ }

  root 'index#index'

  scope '(:locale)', locale: /ru|en/ do
    %w( 422 500 ).each do |code|
      get code, :to => "errors#show", :code => code
    end

    get '/401' => 'errors#unauthorized'
    get '/404' => 'errors#not_found'

    resources :dreams, as: :entry_dreams do
      collection do
        get 'random' => :random
        get 'tagged/:tag' => :tagged, as: :tagged
        get 'of/:login' => :dreams_of_user, as: :user
        get 'archive/(:year)/(:month)' => :archive, as: :archive, constraints: { year: /\d{4}/, month: /(\d|1[0-2])/ }
        get ':id-:uri_title' => :show, as: :verbose
      end
    end

    scope '/dreambook' do
      controller :dreambook do
        get '/' => :index, as: :dreambook
        get '/search' => :search, as: :dreambook_search
        get '/read/:letter/(:word)' => :obsolete, constraints: { letter: /.{,6}/ }
        get '/:letter/:word' => :word, as: :dreambook_word, constraints: { letter: /.{,6}/ }
        get '/:letter' => :letter, as: :dreambook_letter, constraints: { letter: /.{,6}/ }
      end
    end

    resources :grains, only: [:index]

    resources :users, only: [:new, :create]
    resources :comments, :answers, only: [:index, :create]
    resources :deeds, :goals, :languages, :posts, :questions, :fillers
    resources :agents, only: [:index, :show, :edit, :update]

    namespace :my do
      get '/' => 'index#index'

      resource :profile, only: [:show, :edit, :update]
      resource :confirmation, :recovery, only: [:show, :create, :update]
      resources :posts, :deeds, :goals, only: [:index]
      resources :tags, only: [:index, :show, :edit, :update]

      resources :dreams, only: [:index] do
        collection do
          get 'tagged/:tag' => :tagged, as: :tagged
        end
      end

      scope '/statistics' do
        controller :statistics do
          get '/' => :index
          get '/symbols' => :tags
        end
      end
    end

    namespace :admin do
      resources :dream_tags, :users
      resources :comments, only: [:index, :show, :edit, :update, :destroy]
      get "queues/tags"
    end

    controller :sessions do
      get 'login' => :new
      post 'login' => :create
      delete 'logout' => :destroy
    end

    scope '/statistics' do
      controller :statistics do
        get '/' => :index, as: :statistics
        get '/symbols' => :symbols, as: :statistics_symbols
      end
    end

    scope '/about' do
      controller :about do
        get '/' => :index, as: :about
        get '/features' => :features
      end
    end

    get 'u/:login' => 'users#profile', as: :user_profile
    get 'u/:login/posts' => 'users#posts', as: :user_posts
    get 'u/:login/dreams' => 'users#dreams', as: :user_dreams
    get 'u/:login/comments' => 'users#comments', as: :user_comments

    get 'tos' => 'about#terms_of_service'
    get 'privacy' => 'about#privacy'

    get 'sitemap' => 'index#sitemap'
  end

  # Obsolete routes
  get 'articles', to: redirect('/posts')
  get 'articles/:id', to: redirect('/posts/%{id}')
  get 'articles/tagged/:tag', to: redirect('/posts')
  get 'posts/tagged/:tag', to: redirect('/posts')
  get 'forum/posts/:id', to: redirect('/posts/%{id}')
  get 'forum/(:community)(/:id)', to: redirect('/posts')
  get 'about/changelog' => 'index#gone'
  get 'thoughts/(:id)' => 'index#gone'
  get 'my/thoughts' => 'index#gone'
  get 'user/profile' => 'index#gone'
  get 'user/profile/of/:login' => 'index#gone'
  get 'entities/(:id)' => 'index#gone'
  get 'fun/(:type)' => 'index#gone'
end
