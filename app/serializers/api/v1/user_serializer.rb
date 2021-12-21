class Api::V1::UserSerializer < ApplicationSerializer
  attributes :id, :email, :admin, :created_at, :updated_at
end
