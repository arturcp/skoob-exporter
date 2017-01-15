require 'sidekiq/web'

Rails.application.routes.draw do
  resources :crawlers, only: [:index, :create, :show]
  resources :exporter, path: 'exportar', only: :show

  mount Sidekiq::Web, at: '/sidekiq'
  root 'crawlers#index'
end
