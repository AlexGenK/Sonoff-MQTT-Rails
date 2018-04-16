Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :consumers do
  	resources :meters
  end

  get 'open/:id', to: 'open#show'
  
  root 'consumers#index'
end
