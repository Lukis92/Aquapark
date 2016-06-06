Rails.application.routes.draw do
  devise_for :people, controllers: { sessions: 'devise/sessions' },
                      skip: [:registrations]
  devise_for :clients, skip: :sessions,
                       controllers: { registrations: 'client/registrations' }

  resources 'contacts', only: [:new, :create]
  root 'home#index'

  namespace :backend do
    root 'news#index'

    devise_for :people, :manager, :receptionists, :lifeguards, :trainers,
               skip: :sessions,
               controllers: { registrations: 'backend/registrations' }

    resources :entry_types do
      resources :bought_details
      collection do
        get 'bought_list', to: 'entry_types#show'
        get 'search'
      end
    end
    get 'trainers', to: 'people#trainers'

    resources :activities_people
    resources :news do
      member do
        post 'like'
      end
      resources :comments
    end
    resources :work_schedules do
      collection do
        get 'search'
      end
    end
    resources :activities do
      collection do
        get 'search'
      end
      member do
        get 'sign_up'
        get 'preview'
      end
    end

    resources :trainers, only: [:index]
    resources :vacations, except: [:show] do
      collection do
        get 'requests'
        get 'search'
      end
      member do
      post 'accept'
      end
    end
    resources :manage_trainings do
      collection do
        get 'search'
      end
    end
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
            get 'show', as: 'show'
          end
        end

        resources :trainers do
          resources :individual_trainings
            # get 'new', to: '#individual_trainings#choose_date'
        end
        resources :work_schedules, as: 'manage_schedule' do
          collection do
            get 'new', as: 'new'
            get 'my_schedule', to: 'work_schedules#show', as: 'my'
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
    [:managers, :clients, :receptionists, :lifeguards].each do |type|
      get type, to: 'people#' + type.to_s
    end
  end
end
