require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_uniqueness_of(:email).ignoring_case_sensitivity }
    it { is_expected.not_to allow_value('asd').for(:email) }
  end

  describe "associations" do
    it { is_expected.to have_many(:questions) }
    it { is_expected.to have_many(:answers) }
    it { is_expected.to have_many(:awardings) }
  end

  describe "#author_of?" do
    let(:user)           { create(:user) }
    let(:question)       { create(:question, author: user) }
    let(:answer)         { create(:answer, author: user) }
    let(:other_user)     { create(:user) }
    let(:other_question) { create(:question, author: other_user) }
    let(:other_answer)   { create(:answer, author: other_user) }

    context "when user is an author" do
      context "of question" do
        it "returns true" do
          expect(user.author_of?(question)).to be true
        end
      end

      context "of answer" do
        it "returns true" do
          expect(user.author_of?(answer)).to be true
        end
      end
    end

    context "when user is not an author" do
      context "of question" do
        it "returns false" do
          expect(user.author_of?(other_question)).to be false
        end
      end

      context "of answer" do
        it "returns false" do
          expect(user.author_of?(other_answer)).to be false
        end
      end
    end
  end
end
