class Question < ApplicationRecord
  include Votable

  belongs_to :author, class_name: "User", foreign_key: "author_id"
  has_many :answers, dependent: :destroy
  has_many :links, as: :linkable, dependent: :destroy
  has_one :awarding

  validates :title, :body,  presence: true
  validates :title, uniqueness: true

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :awarding, reject_if: :all_blank, allow_destroy: true

  has_many_attached :files
  
end
