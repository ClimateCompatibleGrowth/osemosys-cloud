Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  resources :runs, only: %i[new create index]
  post '/run/:id/start', to: 'runs#start', as: :start_run
end
