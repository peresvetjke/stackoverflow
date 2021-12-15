require "rails_helper"

RSpec.describe VotesController, :type => :controller do

  let(:user)    { create(:user) }
  let(:votable) { create(:question, author: user) }

  describe "POST accept_vote" do
    subject { post :accept, params: {votable: 'questions', id: votable.id, preference: 1, format: :json} }

    shared_examples 'guest' do
      it "keeps unchanged" do
        expect{subject}.not_to change(votable, :rating)
      end
    end
    
    shared_examples 'other user' do
      context 'single vote' do
        it "saves vote in db" do
          subject
          expect(votable.reload.rating).to eq(1)
        end
      end

      context 'repeating vote' do
        let!(:vote) { create(:vote, votable: votable, preference: 1, author: controller.current_user) }
        
        it "cancels previous vote when repeated" do
          subject
          expect(votable.reload.rating).to eq(0)
        end
      end
    end
    
    context "being a guest" do
      it_behaves_like 'guest'
    end

    context 'being an author of votable' do
      before { login(user) }

      it_behaves_like 'guest'
    end

    context 'being not an author of votable' do
      before { login(create(:user)) }

      it_behaves_like 'other user'
    end

    context 'being an admin' do
      before { login(create(:user, admin: true)) }

      it_behaves_like 'other user'
    end
  end
end