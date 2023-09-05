Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users
      get '/auth/current' => 'auth#current'
      post '/auth/signup' => 'auth#signup'
      post '/auth/signin' => 'auth#signin'
      post '/auth/signout' => 'auth#signout'
    end
  end
end
