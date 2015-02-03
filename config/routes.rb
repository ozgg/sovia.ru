Sovia::Application.routes.draw do
  root 'index#index'

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

  resources :articles, as: :entry_articles do
    collection do
      get 'tagged/:tag' => :tagged, as: :tagged
      get ':id-:uri_title' => :show, as: :verbose
    end
  end
  
  resources :posts, as: :entry_posts do
    collection do
      get 'tagged/:tag' => :tagged, as: :tagged
      get ':id-:uri_title' => :show, as: :verbose
    end
  end

  resources :thoughts, as: :entry_thoughts do
    collection do
      get 'tagged/:tag' => :tagged, as: :tagged
      get ':id-:uri_title' => :show, as: :verbose
    end
  end

  resources :grains, as: :entry_grains do
    collection do
      get ':id-:uri_title' => :show, as: :verbose
    end
  end

  resources :users, only: [:new, :create]
  resources :comments, only: [:index, :create]
  resources :deeds, :goals

  namespace :my do
    get '/' => 'index#index'

    resource :profile, only: [:show, :edit, :update]
    resource :confirmation, :recovery, only: [:show, :create, :update]
    resources :posts, :thoughts, :deeds, :grains, :goals, only: [:index]
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
    resources :dream_tags
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
      get '/changelog' => :changelog
    end
  end

  get 'u/:login' => 'users#profile', as: :user_profile
  get 'u/:login/posts' => 'users#posts', as: :user_posts
  get 'u/:login/dreams' => 'users#dreams', as: :user_dreams
  get 'u/:login/comments' => 'users#comments', as: :user_comments

  get 'tos' => 'about#terms_of_service'
  get 'privacy' => 'about#privacy'

  get 'sitemap' => 'index#sitemap'

  # Obsolete routes
  get 'forum/posts/:id', to: redirect('/posts/%{id}')
  get 'forum/(:community)(/:id)', to: redirect('/posts')
  get 'user/profile' => 'index#gone'
  get 'user/profile/of/:login' => 'index#gone'
  get 'entities/(:id)' => 'index#gone'
  get 'fun/(:type)' => 'index#gone'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable
end
