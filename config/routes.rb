Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index', as: 'home_index'

  resources :drivers  do
    member do
      get 'topup'
      patch 'topup' => :save_topup
      get 'location'
      patch 'location' => :update_location
    end
  end

  resources :users do
    member do
      get 'topup'
      patch 'topup' => :save_topup
    end
  end

  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  resources :orders#, only: [:index, :show, :new, :create]

end
