#################### Users ####################
namespace :v1 do
  resources :users, controller: "users" do
    collection do
      get :me
      patch :update_me
      delete :delete_me
    end
  end
end
