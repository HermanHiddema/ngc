Rails.application.routes.draw do
  devise_for :users

  resources :people
  resources :venues
  resources :games
  resources :participants
  resources :matches
  resources :teams
  resources :leagues
  resources :clubs

  resources :seasons

  root to: 'leagues#index'

end
