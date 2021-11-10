class Answer < ApplicationRecord
  # belongs_to :author, class_name: "User", foreign_key: "author_id"
  belongs_to :question

  validates :body, presence: true
  validates :body, uniqueness: { scope: :question_id, message: "already exists for question." }
end
