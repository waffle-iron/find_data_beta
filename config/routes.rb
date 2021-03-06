Rails.application.routes.draw do
  match "/404", :to => "errors#not_found", :via => :all
  match "/500", :to => "errors#internal_server_error", :via => :all

  get 'search/', to: 'search#search'
  get 'search/tips', to: 'search#tips'
  resources :datasets, :path => "dataset", param: :name, only: :show

  root to: 'home#index'
end
