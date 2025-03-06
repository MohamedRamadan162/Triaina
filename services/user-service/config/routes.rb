Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "health" => "health_check#show", as: :health_check
  get "ready" => "health_check#dependencies", as: :ready_check
  # Defines the root path route ("/")
  # root "posts#index"

  # Logged in user routing
  get "/me" => "users#me"
  patch "/me" => "users#update_me"
  delete "/me" => "users#delete_me"

  # All users routing
  get "/" => "users#index"
  get "/:id" => "users#show"
  post "/" => "users#create"
  delete "/:id" => "users#delete"
  patch "/:id" => "users#update"

  post "/signup" => "auth#sign_up"
  post "/login" => "auth#log_in"
end
