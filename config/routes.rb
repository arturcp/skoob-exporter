require 'sidekiq/web'

Rails.application.routes.draw do
  resources :crawlers, only: [:index, :create, :show], path: 'importar'
  resources :exporter, only: :show
  resources :status, path: 'status', only: :show

  mount Sidekiq::Web, at: '/sidekiq'
  root 'crawlers#index'
end
