Rails.application.routes.draw do
  resources :people

  resources :venues

  devise_for :users

  resources :games
  resources :participants
  resources :match_team_members
  resources :team_members
  resources :match_teams
  resources :matches
  resources :teams
  resources :leagues
  resources :seasons
  resources :clubs

  root to: 'leagues#index'

end
