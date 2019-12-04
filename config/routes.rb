Rails.application.routes.draw do
  namespace :users do
    resources :registrations, only: :create
  end

  resources :todos, only: [:index, :create, :update, :destroy] do
    member do
      put 'complete'
      put 'activate'
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
