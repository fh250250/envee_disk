Rails.application.routes.draw do

  root "pages#index"

  get    "login",  to: "sessions#new"
  post   "login",  to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  resources :folders, only: [:show, :edit, :update, :destroy] do
    member do
      get  "make"
      post "make",   action: :perform_make
      get  "move"
      post "move",   action: :perform_move
      get  "upload"
      post "upload", action: :perform_upload
    end
  end

end
