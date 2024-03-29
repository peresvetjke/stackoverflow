require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  use_doorkeeper
  devise_for :users, controllers: { registrations: 'users/registrations', omniauth_callbacks: 'users/omniauth_callbacks' }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: "questions#index"

  get :search, to: "search#index"

  namespace :api do
    namespace :v1 do
      resources :profiles, only: :index do
        get :me, on: :collection
      end

      resources :questions, except: %i[new edit], shallow: true do
        resources :answers, except: %i[new edit]
      end
    end
  end

  resources :questions, shallow: true do
    post :subscribe, on: :member
    post :accept_vote, to: "votes#accept", on: :member, defaults: { votable: 'questions' }

    resources :comments, only: %i[create update destroy], defaults: { commentable: 'questions' }

    resources :answers, shallow: true, except: :index do
      post :accept_vote, to: "votes#accept", on: :member, defaults: { votable: 'answers' }
      resources :comments, only: %i[create update destroy], defaults: { commentable: 'answers' }
    
      post :mark_best, on: :member
    end
  end

  scope :active_storage, module: :active_storage, as: :active_storage do
      resources :attachments, only: :destroy
  end

  resources :awardings, only: :index

  mount ActionCable.server => '/cable'
end
