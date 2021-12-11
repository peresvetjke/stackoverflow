Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations', omniauth_callbacks: 'users/omniauth_callbacks' }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: "questions#index"

  resources :questions, shallow: true do
    post :accept_vote, to: "votes#accept", on: :member, defaults: { votable: 'questions' }
    resources :comments, defaults: { commentable: 'questions' }, only: %i[create update destroy]

    resources :answers, shallow: true, only: %i[create edit update destroy] do
      post :accept_vote, to: "votes#accept", on: :member, defaults: { votable: 'answers' }
      resources :comments, defaults: { commentable: 'answers' }, only: %i[create update destroy]
    
      post :mark_best, on: :member
    end
  end

  resources :attachments, only: :destroy
  resources :awardings, only: :index

  mount ActionCable.server => '/cable'
end
