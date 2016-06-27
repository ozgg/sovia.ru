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

  # Administrative routes
  namespace :admin do
    # Tracking
    resources :browsers, :agents, only: :index
  end

  # API routes
  namespace :api, defaults: { format: :json } do
    # Tracking
    resources :browsers, :agents, concerns: [:toggleable, :lockable]
  end

  # Tracking
  resources :browsers, except: [:index] do
    member do
      get 'agents'
    end
  end
  resources :agents, except: [:index]
end
