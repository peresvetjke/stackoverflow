class Api::V1::LinkSerializer < ApplicationSerializer
  attributes :title, :url

  belongs_to :question
  belongs_to :answer
end