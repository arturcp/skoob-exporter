Rails.application.routes.draw do
  resources :crawlers, only: [:index, :create, :show]
  resources :exporter, path: 'exportar', only: :show

  root 'crawlers#index'
end
