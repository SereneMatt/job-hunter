Rails.application.routes.draw do
  root "sessions#new"

  get "/jobs" => "jobs#index"
  get "/search" => "jobs#search"
  post "/toggle_vote", to: "jobs#toggle_vote"

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
end
