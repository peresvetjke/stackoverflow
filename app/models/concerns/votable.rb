module Votable
  extend ActiveSupport::Concern
  
  included do
    has_many :votes, as: :votable, dependent: :destroy

    def accept_vote(preference:, author:)
      vote = votes.find_or_initialize_by(author: author)

      if vote.persisted? && vote.preference == preference.to_i
        return vote.destroy
      end
      
      vote.update(preference: preference)
      vote.save
    end

    def with_rating
      { id: id, klass: self.class.to_s.underscore, rating: rating }
    end

    def rating
      votes.sum(:preference)
    end
  end
end