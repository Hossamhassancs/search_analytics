Rails.application.routes.draw do
  resources :searches, only: [:index, :create]
  get 'top_searches', to: 'searches#top_searches'
  root 'searches#index'
end
