require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users

  authenticate :user, ->(u) { u.id == 1 } do
    mount Sidekiq::Web => '/sidekiq'
  end

  root to: 'pages#home'
  resources :runs, only: %i[new create index]
  post '/run/:id/start', to: 'runs#start', as: :start_run
end
