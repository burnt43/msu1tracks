Rails.application.routes.draw do
  root to: 'home#index'

  resources :consoles, only: [:show] do
  end
end
