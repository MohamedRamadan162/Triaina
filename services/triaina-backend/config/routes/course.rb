#################### Courses ####################
namespace :v1 do
  resources :courses, controller: "courses", only: [ :index, :show, :create, :destroy, :update ] do
    resources :sections, controller: "courses/course_sections", only: [ :index, :show, :create, :destroy, :update ] do
      resources :units, controller: "courses/sections/section_units", only: [ :index, :show, :create, :destroy, :update ] do
      end
    end
    resources :course_chats, controller: "courses/course_chats", only: [ :index, :show, :create, :destroy, :update ] do
      resources :chat_messages, controller: "courses/course_chats/chat_messages", only: [ :index, :show, :create, :destroy, :update ]
    end
    resources :enrollments, controller: "courses/enrollments", only: [ :index, :show, :destroy ] do
    end
  end
  post "courses/enrollments", to: "courses/enrollments#create"
end
