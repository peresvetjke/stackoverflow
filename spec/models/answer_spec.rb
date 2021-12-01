require 'rails_helper'

RSpec.describe Answer, type: :model do
  
  let(:awarding) { build(:awarding) }
  let(:question) { create(:question, awarding: awarding) }
  let(:answer)   { create(:answer, question: question, body: "Answer") }

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

    it { is_expected.to have_many(:links).dependent(:destroy) }
  end

  it { is_expected.to accept_nested_attributes_for(:links) }
  
  it "have many attached files" do 
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe "#mark_best!" do
    context "without current best answer" do
      it "assigns best mark to selected answer" do
        answer.mark_best!
        expect(answer.reload.best).to be true
      end
    end

    context "having current best answer" do
      let!(:prev_best_answer) { create(:answer, question: question, best: true) }

      it "removes best mark from previous" do
        answer.mark_best!
        expect(prev_best_answer.reload.best).to be false
      end    

      it "assigns best mark to selected answer" do
        answer.mark_best!
        expect(answer.reload.best).to be true
      end

      it "grants awarding to answer's author" do
        expect{answer.mark_best!}.to change(answer.author.awardings, :count).by(1)
      end
    end
  end
end