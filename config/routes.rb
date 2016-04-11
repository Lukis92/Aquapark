Rails.application.routes.draw do
    devise_for :people, controllers: { sessions: 'devise/sessions' }, skip: [:registrations]

    devise_for :managers, skip: :sessions
    devise_for :receptionists, skip: :sessions
    devise_for :lifeguards, skip: :sessions
    devise_for :trainers, skip: :sessions
    devise_for :clients, skip: :sessions

    resources 'contacts', only: [:new, :create]
    root 'home#index'

    namespace :backend do
        root 'people#index'
        resources :entry_types do
          collection do
            get 'buy', to: 'entry_types#show'
          end
            resources :bought_details
        end

        resources :work_schedules, only: [:index, :new, :create]
        resources :people do
            member do
                delete 'remove_photo'
                get 'bought_history', to: 'people#bought_history'
                resources :work_schedules, only: [:edit, :show, :update]
            end
        end

        [:managers, :clients, :receptionists, :trainers, :lifeguards].each do |type|
            get type, to: 'people#' + type.to_s
        end
    end
end
