Rails.application.routes.draw do
  devise_for :people, controllers: { sessions: 'devise/sessions' }, skip: [:registrations]
  devise_for :clients, skip: :sessions

  resources 'contacts', only: [:new, :create]
  root 'home#index'

  namespace :backend do
    root 'people#index'
    resources :entry_types do
      resources :bought_details
      collection do
        get 'bought_list', to: 'entry_types#show'
      end
    end

    resources :work_schedules, only: [:index, :new, :create]
    resources :vacations, except: [:show]
    resources :people do
      member do
        delete 'remove_photo'
        get 'bought_history'
        resources :work_schedules
        resources :vacations, only: [:new, :create] do
          collection do
            get 'list', to: 'vacations#list'
          end
        end
        resources :individual_trainings
      end
    end
    resources :statistics, only: [:index]
    # /das/dsa/users?kind=client|manager|
    [:managers, :clients, :receptionists, :trainers, :lifeguards].each do |type|
      get type, to: 'people#' + type.to_s
    end

    devise_for :managers, skip: :sessions
    devise_for :receptionists, skip: :sessions
    devise_for :lifeguards, skip: :sessions
    devise_for :trainers, skip: :sessions
  end
end
