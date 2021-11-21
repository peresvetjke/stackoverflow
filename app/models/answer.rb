class Answer < ApplicationRecord
  belongs_to :author, class_name: "User", foreign_key: "author_id"
  belongs_to :question

  validates :body, presence: true
  validates :body, uniqueness: { scope: :question_id, message: "already exists for question." }

  has_many_attached :files
  
  default_scope { order(best: :desc) }

  def mark_best!
    Answer.transaction do
      self.question.answers.update_all(best: false)
      self.update!(best: true)
    end
  end
end
