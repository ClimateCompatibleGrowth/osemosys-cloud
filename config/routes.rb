require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users

  authenticate :user, ->(u) { u.id == 1 } do
    mount Sidekiq::Web => '/sidekiq'
  end

  root to: 'pages#home'
  get '/not_authorized', to: 'pages#not_authorized', as: :not_authorized
  get '/not_found', to: 'pages#not_found', as: :not_found

  resources :runs, only: %i[new create show]
  resources :versions, only: %i[new create show]
  resources :models, only: %i[new create index show]
  post '/run/:id/start', to: 'runs#start', as: :start_run
  post '/run/:id/stop', to: 'runs#stop', as: :stop_run
  resources :users, only: %i[show update]

  namespace :admin do
    resources :stats, only: %i[index]
    resources :users, only: %i[index show edit update] do
      resources :runs, only: %i[index]
    end
  end
end
