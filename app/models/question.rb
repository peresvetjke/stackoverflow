class Question < ApplicationRecord
  include Authorable
  include Commentable
  include Votable

  has_many :answers, dependent: :destroy
  has_many :links, as: :linkable, dependent: :destroy
  has_one :awarding
  has_many_attached :files

  validates :title, :body,  presence: true
  validates :title, uniqueness: true

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :awarding, reject_if: :all_blank, allow_destroy: true
  
  after_create_commit :publish_question

  def publish_question
    ActionCable.server.broadcast(
      "questions",
      to_json(include: :author, methods: :rating)
    ) 
  end
end
