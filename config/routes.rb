Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "questions#index"

  resources :questions do
    post :accept_vote, to: "votes#accept", on: :member, defaults: { votable: 'questions' }
    resources :answers, shallow: true, only: %i[create edit update destroy] do
      post :accept_vote, to: "votes#accept", on: :member, defaults: { votable: 'answers' }
    
      post :mark_best, on: :member
    end
  end

  resources :attachments, only: :destroy
  resources :awardings, only: :index

  mount ActionCable.server => '/cable'
end
