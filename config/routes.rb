require 'sidekiq/web'
Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  resources :searches, only: [:index, :create]
  get 'top_searches', to: 'searches#top_searches'
  root 'searches#index'
end
