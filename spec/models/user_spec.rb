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
    it { is_expected.to have_many(:authentications).dependent(:destroy) }
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

  describe "#validate authentication" do
    let(:user)             { build(:user, email: nil) }
    let(:authentication)   { create(:authentication, provider: 'twitter', uid: '123456', user: user) }

    context 'user has been authenticated via provider'
  end

  describe ".from_omniauth" do
    let!(:user)   { create(:user) }
    let(:auth)    { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    let(:service) { double('OmniAuthFinder') }

    it 'calls OmniAuthFinder' do
      expect(OmniAuthFinder).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end

    context 'auth has email' do
      it 'saves email' do
      end

      it 'sets email confirmed' do
      end
    end
    
    context "auth doesn't have email" do
      it 'keeps email blank' do
      end

      it 'keeps email unconfirmed' do
      end
    end
  end
end
