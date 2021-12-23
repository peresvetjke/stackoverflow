# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :omniauthable, omniauth_providers: %i[facebook github]

  has_many :questions, foreign_key: 'author_id'
  has_many :answers, foreign_key: 'author_id'
  has_many :awardings
  has_many :authentications, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :followed_questions, through: :subscriptions, source: :question

  validates :password, :email, presence: true
  validates :email, uniqueness: true
  validates :email, format: /@/

  def self.find_for_oauth(auth)
    Omni::AuthFinder.new(auth).call
  end

  def author_of?(object)
    object.author_id == id
  end

  def create_authentication(provider:, uid:)
    authentications.create!(provider: provider, uid: uid)
  end
end
