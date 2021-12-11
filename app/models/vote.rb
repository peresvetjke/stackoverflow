# frozen_string_literal: true

class Vote < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  belongs_to :votable, polymorphic: true

  validates :preference, inclusion: [-1, 1]
end
