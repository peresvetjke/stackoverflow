require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:body) }

    it 'is expected to be invalid when answer has been already taken' do
      question = create(:question)
      answer = create(:answer, question: question, body: "Answer")
      # author = FactoryBot.create(:user)
      new_answer = build(:answer, question: question, body: "Answer")
      expect(new_answer).to be_invalid
    end
  end

  describe "associations" do
    it { is_expected.to belong_to(:author).class_name('User') }
    it { is_expected.to belong_to(:question) }
  end
end