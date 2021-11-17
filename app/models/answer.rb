class Answer < ApplicationRecord
  belongs_to :author, class_name: "User", foreign_key: "author_id"
  belongs_to :question

  validates :body, presence: true
  validates :body, uniqueness: { scope: :question_id, message: "already exists for question." }

  default_scope { order(best: :desc) }

  def mark_best!
    # binding.pry
    self.question.answers.update_all(best: false)
    self.best = true
    self.save
  end
end
