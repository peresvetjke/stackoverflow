Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "questions#index"

  resources :questions do
    delete "/attachments/:attachment_id", to: "questions#delete_attachment", on: :member
    resources :answers, shallow: true, only: %i[create edit update destroy] do
      post :mark_best, on: :member
      delete "/attachments/:attachment_id", to: "answers#delete_attachment", on: :member
    end
  end
end
