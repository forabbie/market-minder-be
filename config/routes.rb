Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get '/auth/current' => 'auth#current'
      post '/auth/signup' => 'auth#signup'
      post '/auth/signin' => 'auth#signin'
      post '/auth/signout' => 'auth#signout'
      get 'stocks/search' => 'stocks#search'
      get 'stocks/'  => 'stocks#index'
      # resources :stocks, only: [:search]
      resources :users
    end
  end
end
