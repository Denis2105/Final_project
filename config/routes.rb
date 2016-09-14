Rails.application.routes.draw do
  resources :bargains
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get "/", to: 'main#index'
  get "/results", to: 'main#results'

end
