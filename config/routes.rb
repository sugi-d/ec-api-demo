Rails.application.routes.draw do
  namespace :v1 do
    mount_devise_token_auth_for 'User', at: 'users', controllers: {
      registrations: 'v1/users/registrations',
      sessions: 'v1/users/sessions',
    }
    resources :items, only: [:create, :update, :show, :destroy]
    resources :orders, only: [:create, :show]
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'health#index'
end
