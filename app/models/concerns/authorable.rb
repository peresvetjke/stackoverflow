module Authorable
  extend ActiveSupport::Concern
  
  included do
    belongs_to :author, class_name: "User"
    validates :author, presence: true
  end

  def author_name
    "#{author.email}"
  end
end