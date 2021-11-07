class Question < ApplicationRecord
  belongs_to :author, class_name: "User", foreign_key: "author_id"
  has_many :answers

  validates :title, :body, :author_id,  presence: true
  validates :title,                     uniqueness: true
end
