#################### Courses ####################
namespace :v1 do
  resources :courses, controller: "courses", only: [ :index, :show, :create, :destroy, :update ] do
  end
end
