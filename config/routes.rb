Rails.application.routes.draw do
  root to: "questions#index"

  devise_for :users, controllers: { registrations: 'users/registrations', omniauth_callbacks: 'users/omniauth_callbacks' }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :questions, shallow: true do
    post :accept_vote, to: "votes#accept", on: :member, defaults: { votable: 'questions' }
    resources :comments, defaults: { commentable: 'questions' }, only: %i[create update destroy]

    resources :answers, shallow: true do#only: %i[create edit update destroy] do
      post :accept_vote, to: "votes#accept", on: :member, defaults: { votable: 'answers' }
      resources :comments, defaults: { commentable: 'answers' }, only: %i[create update destroy]
    
      post :mark_best, on: :member
    end
  end

  scope :active_storage, module: :active_storage, as: :active_storage do
      resources :attachments, only: :destroy
  end

  resources :awardings, only: :index

  mount ActionCable.server => '/cable'
end
