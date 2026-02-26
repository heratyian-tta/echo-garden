Rails.application.routes.draw do
  get "gardens/index"
  get "gardens/show"
  
  devise_for :users, controllers: {
  sessions: "users/sessions"
}

  root to: "home#index"

  resources :dashboard, only: [:index]

  resources :gardens do
    resources :garden_plots, only: [:create, :update, :destroy]
  end

  resources :garden_plots, only: [:update, :edit, :show] do
  member do
    patch :plant
  end
end

  resources :plants, only: [:index] do
  collection do
    get :autocomplete
    get :search
  end
end

  resources :locations, only: [:index] do
    get :cities, on: :collection
  end
end
