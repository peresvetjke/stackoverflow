class Api::V1::AnswersSerializer < ApplicationSerializer
  attributes :id, :body, :created_at, :updated_at, :author_id
end