Rails.application.routes.draw do
  use_doorkeeper
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "home#index"

  namespace :api do
    namespace :v1 do
      resources :meetings do
        get :dropdown_values, on: :collection
      end
      resources :users do 
      	post :signin, on: :collection
      	delete :signout, on: :collection
        post :auth_login, on: :collection
      end
    end
  end

end
