#################### Sections ####################
namespace :v1 do
  resources :course_sections, controller: "course_sections", only: [ :show, :create, :destroy, :update ] do
  end
end
