require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_uniqueness_of(:email).ignoring_case_sensitivity }
    it { is_expected.not_to allow_value('asd').for(:email) }
  end

  describe "associations" do
    it { is_expected.to have_many(:questions).dependent(:destroy) }
    it { is_expected.to have_many(:answers).dependent(:destroy) }
    it { is_expected.to have_many(:awardings).dependent(:destroy) }
    it { is_expected.to have_many(:authentications).dependent(:destroy) }
    it { is_expected.to have_many(:subscriptions).dependent(:destroy) }
    it { is_expected.to have_many(:followed_questions).class_name("Question") }
  end

  describe ".from_omniauth" do
    let!(:user)   { create(:user) }
    let(:auth)    { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    let(:service) { double('OmniAuthFinder') }

    it 'calls OmniAuthFinder' do
      expect(Omni::AuthFinder).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end
end
