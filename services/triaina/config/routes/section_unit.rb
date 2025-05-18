#################### Section Units ####################
namespace :v1 do
  resources :section_units, controller: "section_units", only: [ :show, :create, :destroy, :update ] do
  end
end
