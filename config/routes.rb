Rails.application.routes.draw do
  get 'studies/chart'
  root 'studies#chart'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
