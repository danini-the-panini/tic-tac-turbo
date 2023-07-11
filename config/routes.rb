Rails.application.routes.draw do
  root "games#index"

  resources :players, only: %i[new create]
  resources :games, only: %i[index create show] do
    post :join, on: :member
    resources :moves, only: %i[create index]
  end
end
