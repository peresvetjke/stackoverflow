class Api::V1::QuestionSerializer < ApplicationSerializer
  attributes :id, :title, :body, :attachments, :created_at, :updated_at

  has_many :comments
  has_many :links
end