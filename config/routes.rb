Rails.application.routes.draw do
  resources :crawlers, only: [:index, :create, :show]
  root 'crawlers#index'
end
