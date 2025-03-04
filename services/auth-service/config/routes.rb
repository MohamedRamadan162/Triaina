Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by k8s load balancers and uptime monitors to verify that the app is live.
  get "health" => "health_check#show", as: :health_check
  get "ready" => "health_check#dependencies", as: :ready_check
end
