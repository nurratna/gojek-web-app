Rails.application.routes.draw do
  # get 'users/index'

  # get 'home/index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index', as: 'home_index'
  
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

end
