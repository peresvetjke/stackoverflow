require "rails_helper"

RSpec.describe CommentsController, :type => :controller do
  
  let(:user)          { create(:user) }
  let(:question)      { create(:question, author: user) }

  context 'commenting question' do
    it_behaves_like 'commented' do 
      let!(:commentable)       { question }
      let(:comment)            { build(:comment, commentable: commentable, author: user)}
      let(:authenticable)      { question }
      let(:commentable_params) { {commentable: 'questions', question_id: commentable} }
    end
  end

  context 'commenting answer' do
    it_behaves_like 'commented' do 
      let!(:commentable)       { create(:answer, question: question, author: user) }
      let(:comment)            { build(:comment, commentable: commentable, author: user)}
      let(:authenticable)      { comment }
      let(:commentable_params) { {commentable: 'answers', answer_id: commentable} }
    end
  end
end