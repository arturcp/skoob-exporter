require 'sidekiq/web'

Rails.application.routes.draw do
  resources :crawlers, only: [:index, :create, :show], path: 'importar'
  resources :exporter, only: :show
  resources :status, path: 'status', only: :show
  resources :feedbacks, only: :create

  if Rails.env.production?
    require 'sidekiq/web'
    Sidekiq::Web.use Rack::Auth::Basic do |username, password|
      username == ENV['ADMIN_EMAIL'] && password == ENV['ADMIN_PASSWORD']
    end
  end

  mount Sidekiq::Web, at: '/sidekiq'
  root 'crawlers#index'
end
