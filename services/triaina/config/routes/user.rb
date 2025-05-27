#################### Users ####################
namespace :v1 do
  resources :users, controller: "users" do
    resources :courses, controller: "users/courses", only: [ :index ]
    collection do
      get :me
      patch :me, to: "users#update_me"
      delete :me, to: "users#delete_me"
    end
  end
end
