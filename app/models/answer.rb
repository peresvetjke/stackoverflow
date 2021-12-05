class Answer < ApplicationRecord
  include Votable
  
  belongs_to :author, class_name: "User", foreign_key: "author_id"
  belongs_to :question
  has_many :links, as: :linkable, dependent: :destroy

  validates :body, presence: true
  validates :body, uniqueness: { scope: :question_id, message: "already exists for question." }

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  
  has_many_attached :files
  
  default_scope { order(best: :desc, created_at: :asc) }

  after_create_commit :publish_answer

  def mark_best!
    Answer.transaction do
      question.answers.update_all(best: false)
      update!(best: true)
      question.awarding&.update!(user: author)
    end
  end

  def publish_answer
    ActionCable.server.broadcast(
      "answers_channel_#{question.id}",
      to_json(include: [:author, :question, :files => {methods: [:filename, :url]}, :links => {methods: [:gist?, :gist_id]} ], methods: :rating)
    ) 
  end
end
