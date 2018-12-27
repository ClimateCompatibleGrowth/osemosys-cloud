Rails.application.routes.draw do
  root to: 'runs#index'
  resources :runs, only: %i[new create index]
  post '/run/:id/start', to: 'runs#start', as: :start_run
end
