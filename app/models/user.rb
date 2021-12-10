class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :omniauthable, omniauth_providers: %i[facebook github]
         
  has_many :questions, foreign_key: "author_id"
  has_many :answers, foreign_key: "author_id"
  has_many :awardings
  has_many :authentications, dependent: :destroy 

  validates :password, presence: true #:email, 
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
  #def email_required?
  #  has_authentication? ? false : super
  #end

  #def has_authentication?
  #  authentications.present?
  #end
end