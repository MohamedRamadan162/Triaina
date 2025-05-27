#################### Courses ####################
namespace :v1 do
  resources :courses, controller: "courses", only: [ :index, :show, :create, :destroy, :update ] do
    resources :sections, controller: "courses/course_sections", only: [ :index, :show, :create, :destroy, :update ] do
      resources :units, controller: "courses/sections/section_units", only: [ :index, :show, :create, :destroy, :update ] do
      end
    end
  end
end
