require "rails_helper"

RSpec.describe VotesController, :type => :controller do

  let(:user) { create(:user) }

  context 'voting question' do
    it_behaves_like 'voted' do 
      let!(:votable)      { create(:question, author: user) }
      let(:authenticable) { votable }
    end
  end

  context 'voting answer' do
    it_behaves_like 'voted' do 
      let!(:votable) { create(:answer, author: user) }
      let(:authenticable) { votable }
    end
  end  
end