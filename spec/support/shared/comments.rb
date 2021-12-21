shared_examples_for 'API Commentable' do  
  let(:comments_response) { json[commentable.class.name.downcase]['comments'] }

  it "returns all associated comments" do
    expect(comments_response.map{ |c| c['id'] }.sort).to eq commentable.comments.ids.sort
  end

  it "returns neccessary fields for comments" do
    %w[id body author_id created_at updated_at].each do |attr|
      expect(comments_response.first[attr]).to eq commentable.comments.first.send(attr).as_json
    end
  end
end

shared_examples 'commented' do
  describe "POST create" do
    subject { post :create, params: {comment: attributes_for(:comment)}.merge(commentable_params), format: :json } 
    
    it_behaves_like "Authenticable", :json

    shared_examples 'authenticated' do
      context "with invalid params" do

        subject { post :create, params: {comment: attributes_for(:comment, :invalid)}.merge(commentable_params), format: :json } 

        it "assigns the commentable to @commentable" do
          subject
          expect(assigns(:commentable)).to eq commentable
        end

        it "doesn't create comment" do
          expect{subject}.not_to change(Comment, :count)
        end

        it "returns unprocessable entity status" do
          subject
          expect(response.status).to eq 422
        end
      end

      context "with valid params" do
        it "assigns the commentable to @commentable" do
          subject
          expect(assigns(:commentable)).to eq commentable
        end

        it 'creates new comment' do
          expect{subject}.to change(Comment, :count).by(1)
        end
      end
    end

    context 'being authenticated' do
      before { login(user) }
      it_behaves_like 'authenticated'
    end
  end

  describe "PATCH update" do
    before { comment.save! }
    subject{ patch :update, params: {commentable: commentable.class.to_s.downcase.pluralize, id: comment, comment: attributes_for(:comment, commentable: commentable, body: "corrections"), format: :json} }

    it_behaves_like "Authenticable", :json

    shared_examples 'not an author of comment' do
      it "doesn't update record" do
        subject
        expect(comment.reload.body).to eq(comment.body)
      end

      it 'returns forbidden status' do
        subject
        expect(response).to have_http_status 403
      end
    end

    shared_examples 'author of comment' do
      context "with invalid params" do
        subject{ patch :update, params: {commentable: commentable.class.to_s.downcase.pluralize, id: comment, comment: attributes_for(:comment, :invalid, commentable: commentable), format: :json} }

        it "assigns the comment to @comment" do
          subject
          expect(assigns(:comment)).to eq comment
        end

        it "doesn't update record" do
          subject
          expect(comment.reload).to eq comment
        end

        it "returns unprocessable entity status" do
          subject
          expect(response.status).to eq 422
        end
      end

      context "with valid params" do
        it "assigns the comment to @comment" do
          subject
          expect(assigns(:comment)).to eq comment
        end

        it "updates record" do
          subject
          expect(comment.reload.body).to eq "corrections"
        end
      end
    end

    context 'being not an author of comment' do
      before { login(create(:user)) }
      it_behaves_like 'not an author of comment'
    end

    context 'being an author of comment' do
      before { login(user) }
      it_behaves_like 'author of comment'
    end

    context 'being an admin' do
      before { login(create(:user, admin: true)) }
      it_behaves_like 'author of comment'
    end
  end

  describe "DELETE destroy" do
    before { comment.save! }
    subject{ delete :destroy, params: {commentable: commentable.class.to_s.downcase.pluralize, id: comment, format: :json} }

    it_behaves_like "Authenticable", :json

    shared_examples 'not an author of comment' do
      it "assigns the comment to @comment" do
        subject
        expect(assigns(:comment)).to eq comment
      end

      it "doesn't delete comment" do
        expect{subject}.not_to change(Comment, :count)
      end

      it 'returns forbidden status' do
        subject
        expect(response).to have_http_status 403
      end
    end

    shared_examples 'author of comment' do
      it "assigns the comment to @comment" do
        subject
        expect(assigns(:comment)).to eq comment
      end

      it "deletes comment" do
        expect{subject}.to change(Comment, :count).by(-1)
      end
    end

    context "being not an author of comment" do
      before { login(create(:user)) }
      it_behaves_like "not an author of comment"
    end

    context "being an author of comment" do
      before { login(user) }
      it_behaves_like "author of comment"
    end

    context "being an admin" do
      before { login(create(:user, admin: true)) }
      it_behaves_like "author of comment"
    end      
  end
end