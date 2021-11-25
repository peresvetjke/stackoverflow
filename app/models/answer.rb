class Answer < ApplicationRecord
  belongs_to :author, class_name: "User", foreign_key: "author_id"
  belongs_to :question
  has_many :links, as: :linkable, dependent: :destroy

  validates :body, presence: true
  validates :body, uniqueness: { scope: :question_id, message: "already exists for question." }

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  
  has_many_attached :files
  
  default_scope { order(best: :desc) }

  def mark_best!
    Answer.transaction do
      self.question.answers.update_all(best: false)
      self.update!(best: true)
    end
  end
end
