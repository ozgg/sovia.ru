Rails.application.routes.draw do
  get '/:locale' => 'index#index', constraints: { locale: /ru|en/ }

  root 'index#index'

  scope '(:locale)', locale: /ru|en/ do
    # Administrative resources
    resources :browsers, :agents, :clients, :tags, :users, :patterns, :codes, :tokens
    resources :violations, only: [:index, :show, :destroy]

    # Common resources
    resources :goals, :deeds, :places, :questions, :grains, :comments, :side_notes

    # Tagged entries
    resources :posts, :dreams do
      collection do
        get 'tagged/:tag_name' => :tagged, as: :tagged
      end
    end

    scope 'dreams', controller: :dreams do
      get 'archive/(:year)/(:month)' => :archive, as: :archive, constraints: { year: /\d{4}/, month: /(\d|1[0-2])/ }
    end

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

      resources :posts, :dreams, only: [:index] do
        collection do
          get 'tagged/:tag_name', action: :tagged, as: :tagged
        end
      end
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

    controller :authentications do
      get 'login' => :new
      post 'login' => :create
      delete 'logout' => :destroy
    end
  end

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

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

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable
end
