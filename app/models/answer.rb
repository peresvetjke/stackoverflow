class Answer < ApplicationRecord
  belongs_to :author, class_name: "User", foreign_key: "author_id"
  belongs_to :question

  validates :question_id, :body, :author_id, presence: true
  validates :body, uniqueness: { scope: :question, message: "of answer can't be repeated." }
end
