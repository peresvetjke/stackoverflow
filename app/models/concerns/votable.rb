module Votable
  extend ActiveSupport::Concern
  
  included do
    def accept_vote(preference:, author:)
      vote = Vote.find_or_initialize_by(votable: self, author: author)
      
      if vote.persisted? && vote.preference == ActiveModel::Type::Boolean.new.cast(preference) 
        return vote.destroy
      end
      
      vote.update(preference: preference)
      vote.save
    end

    def with_rating
      { id: id, klass: self.class.to_s.underscore, rating: rating }
    end

    def rating
      Vote.where(votable: self, preference: true).count - Vote.where(votable: self, preference: false).count
    end
  end
end