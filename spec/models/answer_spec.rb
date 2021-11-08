require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:body) }

    describe "answer uniqueness" do
      answer = FactoryBot.create(:answer, question: FactoryBot.create(:question), body: "Answer")
      author = FactoryBot.create(:user)
      question = answer.question
      before { 
        FactoryBot.build(:answer, question: question, body: "Answer", author: author)
      }
      it 'is exptected to be invalid when answer has been already taken' do
        expect(subject).to be_invalid
      end
    end
  end

  describe "associations" do
    it { is_expected.to belong_to(:author).class_name('User') }
    it { is_expected.to belong_to(:question) }
  end
end