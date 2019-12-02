Rails.application.routes.draw do
  # devise_for :users
  devise_for :users, :controllers => {
    :registrations => 'users/registrations',
    :sessions => 'users/sessions'   
  } 
  resources :users, only: [:index]
  # devise_scope :user do
  #   get "users", :to => "users/sessions#new"
  #   get "sign_out", :to => "users/sessions#destroy" 
  # end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "management#index"
  resources :organizations
  resources :aws_accounts
end
