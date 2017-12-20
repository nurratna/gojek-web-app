Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index', as: 'home_index'

  resources :drivers, except: :destroy  do
    member do
      get 'gopay'
      get 'location'
      patch 'location' => :current_location
      get 'job'
    end
  end

  resources :users, except: :destroy do
    member do
      get 'topup'
      patch 'topup' => :save_topup
      get 'order'
    end
  end

  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  resources :orders, only: [:index, :show, :new, :create]

  namespace :api, defaults: { format: :json }, except: :destroy do
    namespace :v1 do
      resources :users
    end
  end

  namespace :api, defaults: { format: :json }, except: :destroy do
    namespace :v1 do
      resources :drivers
    end
  end

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :orders
    end
  end

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :location_gorides
    end
  end

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :location_gocars
    end
  end

end
