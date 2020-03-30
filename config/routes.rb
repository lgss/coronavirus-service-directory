Rails.application.routes.draw do

  root "services#search"

  get 'auth/auth0/callback' => 'auth0#callback'
  get 'auth/failure' => 'auth0#failure'
  get 'auth/logged-out' => 'auth0#loggedOut'
  get 'logout' => 'logout#logout'

  # public routes
  resources :services, only: [:index] do
    collection do
      get 'search'
    end
  end

  namespace :api do
    resources :services, only: [:index]
  end

  # # admin routes
  # namespace :admin do
  #   # root "services#search"
  #   resources :services
  # end

end
