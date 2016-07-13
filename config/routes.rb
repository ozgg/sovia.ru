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
    resources :browsers, :agents, only: :index
  end

  namespace :api, defaults: { format: :json } do
    resources :browsers, :agents, concerns: [:toggleable, :lockable]
  end

  resources :browsers, except: [:index] do
    member do
      get 'agents'
    end
  end
  resources :agents, except: [:index]
end
