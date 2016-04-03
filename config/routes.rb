Rails.application.routes.draw do
  devise_for :users
  root "grams#index"

  resources :grams, only: [:new, :create, :show, :edit, :update]
end
