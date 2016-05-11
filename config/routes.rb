Rails.application.routes.draw do
  devise_for :people, controllers: { sessions: 'devise/sessions' },
                      skip: [:registrations]
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

    devise_for :receptionists, skip: :sessions
    devise_for :managers, skip: :sessions
    devise_for :lifeguards, skip: :sessions
    devise_for :trainers, skip: :sessions

    resources :work_schedules, only: [:index, :new, :create]
    resources :trainers, only: [:index]
    resources :vacations, except: [:show]
    resources :individual_trainings, except: [:show]
    resources :training_costs
    resources :people do
      collection do
        get 'search'
      end

      member do
        delete 'remove_photo'
        get 'bought_history'

        resources :individual_trainings, only: [:choose_trainer] do
          collection do
            get 'choose_trainer'
          end
        end

        resources :trainers do
          resources :individual_trainings do
              get 'new', to: '#individual_trainings#choose_date'
          end
        end
        resources :work_schedules do
          collection do
            get 'new', as: 'new'
          end
        end
        resources :vacations, only: [:create] do
          collection do
            get 'list'
            get 'new', as: 'new'
          end
        end
      end
    end
    resources :statistics, only: [:index]
    # /das/dsa/users?kind=client|manager|
    [:managers, :clients, :receptionists, :trainers, :lifeguards].each do |type|
      get type, to: 'people#' + type.to_s
    end
  end
end
