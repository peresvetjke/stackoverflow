require "rails_helper"

RSpec.shared_examples_for "votable controller" do

  let(:user)          { create(:user) }
  let(:model)         { described_class.to_s.sub('Controller','').classify }
  let(:votable)       { create(model.to_s.underscore.to_sym) }

  describe "POST vote" do
    context "when unauthorized" do
      it "keeps unchanged" do
        expect{post :accept_vote, params: { id: votable.id, preference: true }}.not_to change(votable, :rating)
      end

      it "renders question show template" do 
        post :accept_vote, params: { id: votable.id, preference: true }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "when authorized" do
      before { login(user) }

      it "saves vote in db" do
        post :accept_vote, params: { id: votable.id, preference: true }
        expect(votable.reload.rating).to eq(1)
      end
    end    
  end
end