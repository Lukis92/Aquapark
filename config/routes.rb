Rails.application.routes.draw do
  devise_for :people, controllers: { sessions: 'devise/sessions' },
                      skip: [:registrations]
  devise_for :clients, skip: :sessions

  authenticated :clients, lambda {|u| u.type == "Client"}do
  end
  authenticated :managers, lambda {|u| u.type == "Manager"}do
  end
  resources 'contacts', only: [:new, :create]
  root 'home#index'

  namespace :backend do
    root 'news#index'

    devise_for :receptionists, :managers, :lifeguards, :trainers,
               skip: :sessions, controllers: {registrations: 'devise/registrations'}

    resources :entry_types do
      resources :bought_details
      collection do
        get 'bought_list', to: 'entry_types#show'
      end
    end
    get 'trainers', to: 'people#trainers'

    resources :news do
      member do
        post 'like'
      end
      resources :comments
    end
    resources :work_schedules, only: [:index, :new, :create]
    resources :trainers, only: [:index]
    resources :vacations, except: [:show] do
      collection do
        get 'requests'
      end
      member do
        post 'accept'
      end
    end
    resources :individual_trainings
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
    [:managers, :clients, :receptionists, :lifeguards].each do |type|
      get type, to: 'people#' + type.to_s
    end
  end
end
