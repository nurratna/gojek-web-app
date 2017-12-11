Rails.application.routes.draw do
  # get 'users/index'

  # get 'home/index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index', as: 'home_index'
  resources :users
end
