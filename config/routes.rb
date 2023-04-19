Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "application#index"

  scope :auth do
    get '/auth0/callback' => 'auth0#callback'
    get '/failure' => 'auth0#failure'
    get '/logout' => 'auth0#logout'
  end

  namespace :api do
    namespace :v1 do
      post :transfer, to: 'account#transfer'
      get :transactions, to: 'account#transactions'
      get :balance, to: 'account#balance'
    end
  end
end
