Rails.application.routes.draw do
  # devise_for :users
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  } 
  resources :users, only: [:index]
  resources :organizations
  resources :aws_accounts

  root to: "managements#index"
  get "instances", to: "managements#instances"
  
  namespace :api do
    namespace :v1 do
      scope :ec2, as: "ec2" do
        post "start", to: "ec2#start"
        post "stop", to: "ec2#stop"
        post "restart", to: "ec2#restart"
      end
    end
  end
end
