Rails.application.routes.draw do
  devise_for :users
  get "posts/index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  resources :households, only: [ :new, :create, :show, :destroy ] do
    collection do
      get :join
      post :join, action: :join_create
      post :switch, action: :switch
      delete :leave, action: :leave
    end
  end

  resources :memos, only: [ :index, :new, :create, :edit, :update, :destroy ]
  resources :items, only: [] do
    member do
      patch :toggle_purchased
    end
  end

  # Letter opener web for viewing emails in development
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  # Static pages
  get "privacy_policy", to: "pages#privacy_policy", as: :privacy_policy

  # Defines the root path route ("/")
  root "home#index"
end
