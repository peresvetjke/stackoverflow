class Api::V1::AnswerSerializer < ApplicationSerializer
  attributes :id, :body, :attachments, :created_at, :updated_at, :author_id

  has_many :comments
  has_many :links
end