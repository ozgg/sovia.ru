Sovia::Application.routes.draw do
  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  controller :dreambook do
    get 'dreambook' => :index
    get 'dreambook/read/:letter/(:word)' => :obsolete, constraints: { letter: /./ }
    get 'dreambook/:letter/:word' => :word, as: :dreambook_word, constraints: { letter: /.{,6}/ }
    get 'dreambook/:letter' => :letter, as: :dreambook_letter, constraints: { letter: /.{,6}/ }
  end


  resources :users, only: [:new, :create]
  resources :articles
  resources :posts
  resources :tags, as: :entry_tags
  resources :dreams do
    collection do
      get 'random' => :random
      get 'tagged/:tag' => :tagged, as: :tagged
    end
  end

  get 'forum/posts/:id', to: redirect('/posts/%{id}')
  get 'forum/(:community)(/:id)', to: redirect('/posts')

  get 'user/profile' => 'index#gone'
  get 'user/profile/of/:login' => 'index#gone'
  get 'entities/(:id)'  => 'index#gone'
  get 'fun/(:type)'   => 'index#gone'

  root 'index#index'

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

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
