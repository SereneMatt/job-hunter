Rails.application.routes.draw do
  root "sessions#new"

  get "/jobs" => "jobs#index"
  get "/search" => "jobs#search"

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'

  post "/toggle_vote", to: "jobs#toggle_vote"
end
