Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    namespace :v1 do
      post :transfer, to: 'account#transfer'
      get :transactions, to: 'account#transactions'
      get :balance, to: 'account#balance'
    end
  end
end
