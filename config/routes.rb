Rails.application.routes.draw do
  use_doorkeeper
  root to: "questions#index"

  devise_for :users, controllers: { registrations: 'users/registrations', omniauth_callbacks: 'users/omniauth_callbacks' }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      resources :profiles, only: %i[index] do
        get :me, on: :collection
        #get :profiles, on: :collection
      end
    end
  end

  resources :questions, shallow: true do
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
