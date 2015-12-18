Rails.application.routes.draw do
  root to: 'homepage#index'

  resources :users, only: [:new, :create]

  resources :transactions, only: [:index, :create] do
    collection do
      get :withdraw
      get :pay
    end
  end
end
