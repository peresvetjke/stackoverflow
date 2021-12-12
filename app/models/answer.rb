class Answer < ApplicationRecord
  include Authorable
  include Commentable
  include Votable

  default_scope { order(best: :desc, created_at: :asc) }

  belongs_to :question
  has_many :links, as: :linkable, dependent: :destroy
  has_many_attached :files

  validates :body, presence: true
  validates :body, uniqueness: { scope: :question_id, message: 'already exists for question.' }

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

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
      "questions/#{question.id}/answers",
      to_json(include: [:author,
                        :question,
                        { files: { methods: %i[filename url] },
                          links: { methods: %i[gist? gist_id] } }],
              methods: :rating)
    )
  end
end
