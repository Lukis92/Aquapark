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
    resources :people do
      member do
         get 'edit_profile'
         delete 'remove_photo'
      end
    end
    [:managers, :clients, :receptionists, :trainers, :lifeguards].each do |type|
       get type, to: "people#index"
    end
  end

  # namespace :backend do
  #     resources :people, except: [:new, :create] do
  #       get '/profile', to: 'people#show_profile'
  #       get '/edit_profile', to: 'people#edit_profile'
  #     end
  #     resources :managers, except: [:new, :create]
  #
  #     resources :clients, except: [:new, :create]
  #
  #     resources :receptionists, except: [:new, :create]
  #
  #     resources :trainers, except: [:new, :create]
  #
  #     resources :lifeguards, except: [:new, :create]
  # end
end
