Rails.application.routes.draw do
  root to: 'home#index'

  resources :consoles, only: [:show] do
  end

  resources :videogames, only: [:show] do
    member do
      get :download_music_tracks
    end
  end

  resources :music_tracks, only: [] do
    member do
      get :download
    end
  end
end
