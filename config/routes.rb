Rails.application.routes.draw do

  root "pages#index"

  get    "login",  to: "sessions#new"
  post   "login",  to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  scope "disk" do
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

    resources :uploads, only: [] do
      member do
        post "part"
      end
    end

    resources :meta_files, only: [:show, :edit, :update, :destroy] do
      member do
        get  "move"
        post "move",   action: :perform_move
        get  "preview"
        get  "download"
      end
    end
  end

end
