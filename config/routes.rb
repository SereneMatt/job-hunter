Rails.application.routes.draw do
  root "jobs#index"

  get "/search" => "jobs#search"
end
