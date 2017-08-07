Rails.application.routes.draw do
  get 'search/', to: 'search#search'
  get 'search/tips', to: 'search#tips'
  get 'api/organisations', to: 'organisations#lookup'
  root to: 'home#index'

  resources :datasets, :path => "dataset", only: :show
end
