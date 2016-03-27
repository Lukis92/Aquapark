Rails.application.routes.draw do
  devise_for :managers, skip: [:sessions, :registrations]
  devise_for :receptionists, skip: [:sessions, :registrations]
  devise_for :lifeguards, skip: [:sessions, :registrations]
  devise_for :trainers, skip: [:sessions, :registrations]
  devise_for :clients, skip: :sessions
  get '/contacts',     to: 'contacts#new'
  resources "contacts", only: [:new, :create]
  devise_for :people, skip: [:registrations] do
    get '/login', to: 'sessions#new', as: :new_person_session
    post '/login', to: 'sessions#create', as: :person_session
    delete '/logout', to: 'sessions#destroy', as: :destroy_person_session

  end
  root 'home#index'

  namespace :backend do
    resources :work_schedules
    resources :entry_types
    resources :people do
        member do
           get 'edit_profile'
           delete 'remove_photo'
           get 'work_schedule', to: 'work_schedules#show'
           get 'add_work_schedule', to: 'work_schedules#new'
        end
    end

    [:managers, :clients, :receptionists, :trainers, :lifeguards].each do |type|
       get type, to: "people#"+type.to_s
    end
  end
end
