require "rails_helper"

RSpec.describe CommentsController, :type => :controller do
  
  let(:user)     { create(:user) }
  let(:question) { create(:question, author: user) }

  shared_examples 'commentable' do
    describe "POST create" do
      subject { post :create, params: {comment: attributes_for(:comment)}.merge(commentable_params), format: :json } 
      
      shared_examples 'guest' do
        it 'keeps count unchanged' do
          expect{subject}.not_to change(Comment, :count)
        end        
        
        it 'redirects to root path' do
          subject
          expect(response).to redirect_to root_path
        end
      end

      shared_examples 'authenticated' do
        it "assigns the commentable to @commentable" do
          subject
          expect(assigns(:commentable)).to eq commentable
        end

        it 'creates new comment' do
          expect{subject}.to change(Comment, :count).by(1)
        end
      end

      context 'being guest' do
        it_behaves_like 'guest'
      end

      context 'being authenticated' do
        before { login(user) }
        it_behaves_like 'authenticated'
      end
    end

    describe "PATCH update" do
      before { comment.save! }
      subject{ patch :update, params: {commentable: commentable.class.to_s.downcase.pluralize, id: comment, comment: attributes_for(:comment, commentable: commentable, body: "corrections"), format: :json} }

      shared_examples 'guest' do
        it "doesn't update record" do
          subject
          expect(comment.reload.body).to eq(comment.body)
        end

        it "redirects to root path" do
          subject
          expect(response).to redirect_to root_path
        end
      end

      shared_examples 'author of comment' do
        it "assigns the comment to @comment" do
          subject
          expect(assigns(:comment)).to eq comment
        end

        it "updates record" do
          subject
          expect(comment.reload.body).to eq "corrections"
        end
      end

      context 'being a guest' do
        it_behaves_like 'guest'
      end

      context 'being not an author of comment' do
        before { login(create(:user)) }
        it_behaves_like 'guest'
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

      it "assigns the comment to @comment" do
        subject
        expect(assigns(:comment)).to eq comment
      end

      shared_examples 'guest' do
        it "doesn't delete comment" do
          expect{subject}.not_to change(Comment, :count)
        end

        it "redirects to root path" do
          subject
          expect(response).to redirect_to root_path
        end
      end

      shared_examples 'author of comment' do
        it "deletes comment" do
          expect{subject}.to change(Comment, :count).by(-1)
        end
      end

      context "being a guest" do
        it_behaves_like "guest"
      end

      context "being not an author of comment" do
        before { login(create(:user)) }
        it_behaves_like "guest"
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

  context 'commenting question' do
    it_behaves_like 'commentable' do 
      let!(:commentable)       { question }
      let(:comment)            { build(:comment, commentable: commentable, author: user)}
      let(:commentable_params) { {commentable: 'questions', question_id: commentable} }
    end
  end

  context 'commenting answer' do
    it_behaves_like 'commentable' do 
      let!(:commentable)       { create(:answer, question: question, author: user) }
      let(:comment)            { build(:comment, commentable: commentable, author: user)}
      let(:commentable_params) { {commentable: 'answers', answer_id: commentable} }
    end
  end
end