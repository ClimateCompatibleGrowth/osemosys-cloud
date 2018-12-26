Rails.application.routes.draw do
  resources :runs, only: %i[new create index]
  post '/run/:id/start', to: 'runs#start', as: :start_run
end
