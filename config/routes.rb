Rails.application.routes.draw do
  # Collections that have tags and archive (e.g. posts and dreams)
  concern :tagged_archive do
    collection do
      get 'tagged/:tag_name' => :tagged, as: :tagged
      get 'archive/(:year)/(:month)' => :archive, as: :archive, constraints: { year: /\d{4}/, month: /(\d|1[0-2])/ }
    end
  end

  get '/:locale' => 'index#index', constraints: { locale: /ru|en/ }

  root 'index#index'

  scope '(:locale)', locale: /ru|en/ do
    # Administrative resources
    resources :browsers, :agents, :clients, :tags, :users, :patterns, :codes, :tokens
    resources :violations, only: [:index, :show, :destroy]

    # Common resources
    resources :goals, :deeds, :places, :questions, :grains, :comments, :side_notes

    # Tagged resources with archive
    resources :posts, :dreams, concerns: :tagged_archive

    # Dreambook
    scope 'dreambook', controller: :dreambook do
      get '/' => :index, as: :dreambook
      get 'search' => :search, as: :dreambook_search
      get ':letter' => :letter, as: :dreambook_letter
      get ':letter/:word' => :word, as: :dreambook_word
    end

    # Namespace for current user
    namespace :my do
      resource :profile, except: [:destroy]
      resource :confirmation, :recovery, only: [:show, :create, :update]
      resources :goals, :deeds, :places, :questions, :grains, :comments, :side_notes, only: [:index]
      resources :posts, :dreams, only: [:index], concerns: :tagged_archive

      get '/' => 'index#index'
    end

    # Scope of certain user
    scope 'u/(:uid)', controller: :users do
      get '/' => :profile
      get 'posts', as: :user_posts
      get 'dreams', as: :user_dreams
      get 'questions', as: :user_questions
      get 'comments', as: :user_comments
      get 'patterns', as: :user_patterns
    end

    # Authentication
    controller :authentications do
      get 'login' => :new
      post 'login' => :create
      delete 'logout' => :destroy
    end

    # About project, terms of service and privacy
    controller :about do
      get 'about' => :index
      get 'about/features' => :features
      get 'tos' => :terms_of_service
      get 'privacy'
    end
  end

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
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
end
