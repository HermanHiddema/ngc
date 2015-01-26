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

  resources :seasons do
    resources :leagues
    resources :teams
    resources :matches
    resources :participants
  end

  resources :leagues do
    resources :teams
  end

  root to: 'leagues#index'

end
