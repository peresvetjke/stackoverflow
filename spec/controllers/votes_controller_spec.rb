require "rails_helper"

RSpec.describe VotesController, :type => :controller do

  let(:user)    { create(:user) }
  let(:votable) { create(:question) }

  describe "POST accept_vote" do
    context "when unauthorized" do
      it "keeps unchanged" do
        expect{post :accept, params: { votable: 'questions', id: votable.id, preference: 1, format: :json }}.not_to change(votable, :rating)
      end
    end

    context "when authorized" do
      before { login(user) }
      it "saves vote in db" do
        post :accept, params: { votable: 'questions', id: votable.id, preference: 1, format: :json }
        expect(votable.reload.rating).to eq(1)
      end
    end    
  end
end