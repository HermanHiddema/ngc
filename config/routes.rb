Rails.application.routes.draw do
  devise_for :users

  resources :people
  resources :venues
  resources :games, only: [:index]
  resources :participants
  resources :matches
  resources :teams
  resources :leagues
  resources :clubs
  resources :seasons

  get 'club', to:  redirect('/clubs')

  root to: 'leagues#index'

end
