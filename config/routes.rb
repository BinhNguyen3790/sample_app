Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    # Setting the root route
      root "static_pages#home"

      get "sessions/new"

      # The routes for the home and help actions in the Static Pages controller
      get "/home", to: "static_pages#home"
      get "/help", to: "static_pages#help"
      get "/about", to: "static_pages#about"
      get "/contact", to: "static_pages#contact"

      get "/signup", to: "users#new"
      post "/signup", to: "users#create"
      get "/login", to: "sessions#new"
      post "/login", to: "sessions#create"
      delete "/logout", to: "sessions#destroy"

      get "password_resets/new"
      get "password_resets/edit"

      resources :users do
        member do
          get :following, :followers
        end
      end
      resources :account_activations, only: [:edit]
      resources :password_resets, only: [:new, :create, :edit, :update]
      resources :microposts, only: [:create, :destroy]
      resources :relationships, only: [:create, :destroy]
  end
end
