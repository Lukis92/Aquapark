Rails.application.routes.draw do
  devise_for :managers, skip: [:sessions, :registrations]
  devise_for :receptionists, skip: [:sessions, :registrations]
  devise_for :lifeguards, skip: [:sessions, :registrations]
  devise_for :trainers, skip: [:sessions, :registrations]
  devise_for :clients, skip: :sessions


  devise_for :people, skip: [:registrations] do
    get '/login', to: 'sessions#new', as: :new_person_session
    post '/login', to: 'sessions#create', as: :person_session
    delete '/logout', to: 'sessions#destroy', as: :destroy_person_session
  end
  root 'home#index'

  namespace :backend do
      resources :managers, except: [:new, :create] do
        get '/profile', to: 'managers#show_profile'
      end

      resources :clients, except: [:new, :create] do
        get '/profile', to: 'clients#show_profile'
      end

      resources :receptionists, except: [:new, :create] do
        get '/profile', to: 'receptionists#show_profile'
      end

      resources :trainers, except: [:new, :create] do
        get '/profile', to: 'trainers#show_profile'
      end

      resources :lifeguards, except: [:new, :create] do
        get '/profile', to: 'lifeguards#show_profile'
      end
  end
end
