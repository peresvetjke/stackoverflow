class Api::V1::QuestionsSerializer < ApplicationSerializer
  attributes :id, :title, :body, :created_at, :updated_at
end