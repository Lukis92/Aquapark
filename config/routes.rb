Rails.application.routes.draw do
  devise_for :clients, skip: :sessions

  devise_for :people, skip: [:registrations] do
    get '/login', to: 'sessions#new', as: :new_person_session
    post '/login', to: 'sessions#create', as: :person_session
    delete '/logout', to: 'sessions#destroy', as: :destroy_person_session
  end
  root 'home#index'

  namespace :backend do
    resources :clients, except: [:new, :create] do
      get '/profile', to: 'clients#show_profile'
    end
  end
end
