class User < ApplicationRecord
  has_many :questions, foreign_key: "author_id"
  has_many :answers, foreign_key: "author_id"
end
