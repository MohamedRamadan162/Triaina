#################### Courses ####################
namespace :v1 do
  resources :courses, controller: "courses", only: [ :index, :show, :create, :destroy, :update ] do
    resources :sections, controller: "courses/course_sections", only: [ :index, :show, :create, :destroy, :update ] do
      resources :units, controller: "courses/sections/section_units", only: [ :index, :show, :create, :destroy, :update ] do
      end
    end
    resources :chat_channels, controller: "courses/chat_channels", only: [ :index, :show, :create, :destroy, :update ] do
      resources :chat_messages, controller: "courses/chat_channels/chat_messages", only: [ :index, :show, :create, :destroy, :update ]
    end
    resources :enrollments, controller: "courses/enrollments", only: [ :index, :show, :create, :destroy ] do
    end
  end
end
