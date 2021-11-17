require 'rails_helper'

RSpec.describe Answer, type: :model do
  
  let(:question) { create(:question) }
  let(:answer)   { create(:answer, question: question, body: "Answer") }
  # let(:answers)  { create_list(:answer, 5), question: question }

  describe "validations" do
    it { is_expected.to validate_presence_of(:body) }

    it 'is expected to be invalid when answer has been already taken' do
      answer
      expect(build(:answer, question: question, body: "Answer")).to be_invalid
    end
  end

  describe "associations" do
    it { is_expected.to belong_to(:author).class_name('User') }
    
    it { is_expected.to belong_to(:question) }
  end

  describe "#mark_best!" do
    context "without current best answer" do
      it "assigns best mark to selected answer" do
        answer.mark_best!
        expect(answer.reload.best).to be true
      end
    end

    context "having best answer" do
      let!(:prev_best_answer) { create(:answer, question: question, best: true) }
      before { answer.mark_best! }
      
      it "assigns best mark to selected answer" do
        expect(answer.reload.best).to be true
      end    

      it "removes best mark from previous" do
        answer.mark_best!
        expect(prev_best_answer.reload.best).to be false
      end    
    end
  end
end