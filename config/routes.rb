Rails.application.routes.draw do
  get 'studies/chart'
  root 'studies#chart'
end
