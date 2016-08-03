Rails.application.routes.draw do
  devise_for :people, controllers: { sessions: 'devise/sessions' },
                      skip: [:registrations]
  devise_for :clients, skip: :sessions,
                       controllers: { registrations: 'client/registrations' }

  resources 'contacts', only: [:new, :create]
  root 'home#index'

  namespace :backend do
    root 'news#index'

    resources :products
    devise_for :people, :manager, :receptionists, :lifeguards, :trainers,
               skip: :sessions,
               controllers: { registrations: 'backend/registrations' }

    resources :entry_types do
      resources :bought_details, except: [:show, :edit, :update]
      collection do
        get 'bought_list', to: 'entry_types#show'
        get 'search'
      end
    end
    get 'trainers', to: 'people#trainers'

    resources :activities_people, except: [:show, :new, :edit]
    resources :news do
      member do
        post 'like'
      end
      resources :comments, only: [:create, :edit, :update, :destroy]
    end
    resources :work_schedules do
      collection do
        get 'search'
      end
    end
    resources :activities, except: [:show] do
      collection do
        get 'search'
        get 'pool_zone'
        get 'requests'
      end
      member do
        get 'sign_up'
        get 'preview'
        post 'activate'
        post 'deactivate'
      end
    end

    resources :vacations, only: [] do
      collection do
        get 'requests'
        get 'search'
      end
      member do
        post 'accept'
      end
    end

    # Manage vacations
    resources :manage_vacations, only: :index
    resources :individual_trainings, only: [:index, :show, :edit, :search] do
      collection do
        get 'search'
      end
    end
    resources :training_costs, except: [:show]
    resources :people, except: [:new, :create] do
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
            get 'show_details'
          end
        end

        resources :trainers, only: [] do
          resources :individual_trainings
        end
        resources :work_schedules, as: 'manage_schedule' do
          collection do
            get 'new', as: 'new'
            get 'my_schedule', to: 'work_schedules#show', as: 'my'
          end
        end
        resources :vacations, param: :vacation_id, except: [:show]
      end
    end
    resources :statistics, only: [:index]
    # /das/dsa/users?kind=client|manager|
    [:managers, :clients, :receptionists, :lifeguards].each do |type|
      get type, to: 'people#' + type.to_s
    end
  end
end
