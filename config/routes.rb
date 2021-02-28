require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users

  authenticate :user, ->(u) { u.id == 1 } do
    mount Sidekiq::Web => '/sidekiq'
  end

  root to: 'pages#home'
  resources :runs, only: %i[new create show]
  resources :versions, only: %i[new create show]
  resources :models, only: %i[new create index show]
  post '/run/:id/start', to: 'runs#start', as: :start_run
  post '/run/:id/stop', to: 'runs#stop', as: :stop_run
  resources :users, only: %i[show update]

  namespace :admin do
    resources :user_stats, only: %i[index]
    resources :users, only: %i[index show edit update] do
      resources :runs, only: %i[index]
    end
  end
end
