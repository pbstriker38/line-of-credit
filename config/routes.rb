Rails.application.routes.draw do
  root to: 'homepage#index'

  resources :users, only: [:new, :create]
end
