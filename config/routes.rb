Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do

      # auth
      get '/auth/current' => 'auth#current'
      post '/auth/signup' => 'auth#signup'
      post '/auth/signin' => 'auth#signin'
      post '/auth/signout' => 'auth#signout'

      get '/stocks'  => 'stocks#index' # list stocks from cloud
      get '/stocks/search' => 'stocks#search' # search stocks from cloud
      get '/stocks/top' => 'stocks#top_stocks' # list top 10 stocks from cloud
      get '/stocks/local' => 'stocks#local_stocks' # list all local stocks
      get '/stocks/portfolio' => 'stocks#user_portfolio' # list all users available stocks
      
      # users/traders
      patch '/users/deposit', to: 'users#deposit_cash'
      get '/users/transactions', to: 'transactions#return_user_transactions'

      get '/transactions', to: 'transactions#index'
      post '/transactions', to: 'transactions#create'
      # resources :transactions
      resources :users
    end
  end
end
