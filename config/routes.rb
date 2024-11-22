Rails.application.routes.draw do
  mount Plutus::Engine, at: "/plutus"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  namespace :onchain_billing do
    resources :contracts
  end
  get 'home/index'
  post '/earn_reward', to: 'home#earn_reward', as: :simulate_reward
  post '/pay_fee', to: 'home#pay_fee', as: :simulate_fee_payment
  post '/sweep', to: 'home#sweep', as: :simulate_sweep

  namespace :webhooks do
    namespace :quick_node do
      resources :events, only: :create
    end
  end


  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"
end
