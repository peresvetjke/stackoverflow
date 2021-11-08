class User < ApplicationRecord
  has_many :questions, foreign_key: "author_id"
  has_many :answers, foreign_key: "author_id"

  validates :email, :password, :login, presence: true
  validates :email, :login, uniqueness: true
  validates :email, format: /@/
end