Rails.application.routes.draw do
  root "forecasts#index"

  resources :forecasts
end
