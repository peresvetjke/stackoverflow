shared_examples 'voted' do
  describe "POST accept_vote" do
    subject { post :accept, params: {votable: "#{votable.class.to_s.downcase.pluralize}", id: votable.id, preference: 1, format: :json} }

    it_behaves_like "Authenticable", :json

    shared_examples 'author of votable' do
      it "keeps unchanged" do
        expect{subject}.not_to change(votable, :rating)
      end

        include_examples "it_returns_status", 403
    end

    shared_examples 'not an author of votable' do
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

    context 'being an author of votable' do
      before { login(user) }

      it_behaves_like 'author of votable'
    end

    context 'being not an author of votable' do
      before { login(create(:user)) }

      it_behaves_like 'not an author of votable'
    end

    context 'being an admin' do
      before { login(create(:user, admin: true)) }

      it_behaves_like 'not an author of votable'
    end
  end
end