class Api::V1::CommentSerializer < ApplicationSerializer
  attributes :id, :body, :author_id, :created_at, :updated_at
end