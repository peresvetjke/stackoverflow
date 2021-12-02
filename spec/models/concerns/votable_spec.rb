require "rails_helper"

RSpec.shared_examples_for "votable" do
  let(:user)          { create(:user) }
  let(:model)         { described_class }
  let(:votable)       { create(model.to_s.underscore.to_sym) }
  let(:positive_vote) { create(:vote, votable: votable, author: user, preference: 1) }
  let(:negative_vote) { create(:vote, votable: votable, author: user, preference: -1) }

  describe "associations" do
    it { is_expected.to have_many(:votes).dependent(:destroy) }
  end

  describe "#vote" do
    context "when preference is positive" do
      context "with no previous vote from author" do
        it "increases rating by one" do
          expect{votable.accept_vote(author: user, preference: 1)}.to change(votable, :rating).by(1)
        end
      end

      context "with previous positive vote from author" do
        before { positive_vote }
        it "removes previous vote" do
          expect{votable.accept_vote(author: user, preference: 1)}.to change(votable, :rating).by(-1)
        end
      end

      context "with previous negative vote from author" do
        before { negative_vote }
        it "increases rating by two" do
          expect{votable.accept_vote(author: user, preference: 1)}.to change(votable, :rating).by(2)
        end
      end
    end
    
    context "when preference is negative" do
      context "with no previous vote from author" do
        it "decreases rating by one" do
          expect{votable.accept_vote(author: user, preference: -1)}.to change(votable, :rating).by(-1)
        end
      end
      
      context "with previous positive vote from author" do
        before { positive_vote }
        it "decreases rating by two" do
          expect{votable.accept_vote(author: user, preference: -1)}.to change(votable, :rating).by(-2)
        end
      end
      
      context "with previous negative vote from author" do
        before { negative_vote }
        it "removes previous vote" do
          expect{votable.accept_vote(author: user, preference: -1)}.to change(votable, :rating).by(1)
        end
      end
    end
  end
end