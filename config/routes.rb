Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'forecast', controller: :forecasts
  root 'forecasts#forecast'
end
