Rails.application.routes.draw do
  resources :runs, only: %i[new create index]
end
