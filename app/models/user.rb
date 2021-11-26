class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  has_many :questions, foreign_key: "author_id"
  has_many :answers, foreign_key: "author_id"
  has_many :awardings

  validates :email, :password, presence: true
  validates :email, uniqueness: true
  validates :email, format: /@/

  def author_of?(object)
    object.author_id == self.id
  end
end