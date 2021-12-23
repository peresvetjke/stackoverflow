class Api::V1::QuestionSerializer < ApplicationSerializer
  attributes :id, :title, :body, :created_at, :updated_at, :attachments

  has_many :comments
  has_many :links
end